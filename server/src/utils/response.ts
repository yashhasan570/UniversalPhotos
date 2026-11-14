import { CookieOptions, Response } from 'express';
import { Duration } from 'luxon';
import { Writable } from 'node:stream';
import { CookieResponse } from 'src/dtos/auth.dto.js';
import { UniversalPhotosCookie } from 'src/enum.js';

export class ClientDisconnectedError extends Error {}

export const waitForDrain = (response: Writable) =>
  new Promise<void>((resolve, reject) => {
    const cleanup = () => {
      response.off('drain', onDrain);
      response.off('close', onClose);
      response.off('error', onError);
    };

    const onDrain = () => {
      cleanup();
      resolve();
    };

    const onClose = () => {
      cleanup();
      reject(new ClientDisconnectedError());
    };

    const onError = (error: Error) => {
      cleanup();
      reject(error);
    };

    response.once('drain', onDrain);
    response.once('close', onClose);
    response.once('error', onError);

    // 'close' may already have fired
    if (response.destroyed) {
      onClose();
    }
  });

export const respondWithCookie = <T>(res: Response, body: T, { isSecure, values }: CookieResponse) => {
  const defaults: CookieOptions = {
    path: '/',
    sameSite: 'lax',
    httpOnly: true,
    secure: isSecure,
    maxAge: Duration.fromObject({ days: 400 }).toMillis(),
  };

  const cookieOptions: Record<UniversalPhotosCookie, CookieOptions> = {
    [UniversalPhotosCookie.AuthType]: defaults,
    [UniversalPhotosCookie.AccessToken]: defaults,
    [UniversalPhotosCookie.MaintenanceToken]: { ...defaults, maxAge: Duration.fromObject({ days: 1 }).toMillis() },
    [UniversalPhotosCookie.OAuthState]: defaults,
    [UniversalPhotosCookie.OAuthCodeVerifier]: defaults,
    // no httpOnly so that the client can know the auth state
    [UniversalPhotosCookie.IsAuthenticated]: { ...defaults, httpOnly: false },
    [UniversalPhotosCookie.SharedLinkToken]: { ...defaults, maxAge: Duration.fromObject({ days: 1 }).toMillis() },
  };

  for (const { key, value } of values) {
    if (value === null) {
      continue;
    }
    const options = cookieOptions[key];
    res.cookie(key, value, options);
  }

  return body;
};

export const respondWithoutCookie = <T>(res: Response, body: T, cookies: UniversalPhotosCookie[]) => {
  for (const cookie of cookies) {
    res.clearCookie(cookie);
  }

  return body;
};
