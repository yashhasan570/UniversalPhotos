import * as React from 'react';
import { Column, Img, Link, Row, Text } from 'react-email';

export const UniversalPhotosFooter = () => (
  <>
    <Row className="h-18 w-full">
      <Column align="center" className="w-6/12 sm:w-full">
        <div>
          <Link href="https://play.google.com/store/apps/details?id=app.alextran" className="object-contain">
            <Img
              alt="Get it on Google Play"
              className="max-w-full"
              src={`https:///img/google-play-badge.png`}
            />
          </Link>
        </div>
      </Column>
      <Column align="center" className="w-6/12 sm:w-full">
        <div className="h-full p-6">
          <Link href="https://apps.apple.com/sg/app/universalphotos/id1613945652">
            <Img
              alt="Download on the App Store"
              className="max-w-full"
              src={`https:///img/ios-app-store-badge.png`}
            />
          </Link>
        </div>
      </Column>
    </Row>

    <Text className="text-center text-sm text-universalphotos-footer">
      <Link href="https://">UniversalPhotos</Link> project is available under GNU AGPL v3 license.
    </Text>
  </>
);
