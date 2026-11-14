import * as React from 'react';
import { Link, Section, Text } from 'react-email';
import { UniversalPhotosButton } from 'src/emails/components/button.component.js';
import UniversalPhotosLayout from 'src/emails/components/universalphotos.layout.js';
import { WelcomeEmailProps } from 'src/repositories/email.repository.js';
import { replaceTemplateTags, templatePreview } from 'src/utils/replace-template-tags.js';

export const WelcomeEmail = ({ baseUrl, displayName, username, password, customTemplate }: WelcomeEmailProps) => {
  const usableTemplateVariables = {
    displayName,
    username,
    password,
    baseUrl,
  };

  const emailContent = customTemplate ? (
    replaceTemplateTags(customTemplate, usableTemplateVariables)
  ) : (
    <>
      <Text className="m-0">
        Hey <strong>{displayName}</strong>!
      </Text>

      <Text>A new account has been created for you.</Text>

      <Text>
        <strong>Username</strong>: {username}
        {password && (
          <>
            <br />
            <strong>Password</strong>: {password}
          </>
        )}
      </Text>
    </>
  );

  return (
    <UniversalPhotosLayout
      preview={
        customTemplate
          ? templatePreview(customTemplate, usableTemplateVariables)
          : 'You have been invited to a new UniversalPhotos instance.'
      }
    >
      {customTemplate && (
        <Text className="m-0">
          <div dangerouslySetInnerHTML={{ __html: emailContent }}></div>
        </Text>
      )}

      {!customTemplate && emailContent}

      <Section className="flex justify-center my-6">
        <UniversalPhotosButton href={`${baseUrl}/auth/login`}>Login</UniversalPhotosButton>
      </Section>

      <Text className="text-xs">
        If you cannot click the button use the link below to proceed with first login.
        <br />
        <Link href={baseUrl}>{baseUrl}</Link>
      </Text>
    </UniversalPhotosLayout>
  );
};

WelcomeEmail.PreviewProps = {
  baseUrl: 'https://demo./auth/login',
  displayName: 'Alan Turing',
  username: 'alanturing@',
  password: 'mysuperpassword',
} as WelcomeEmailProps;

export default WelcomeEmail;
