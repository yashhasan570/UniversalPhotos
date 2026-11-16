import * as React from 'react';
import { Link, Row, Text } from 'react-email';
import UniversalPhotosLayout from 'src/emails/components/universal_photos.layout.js';
import { TestEmailProps } from 'src/repositories/email.repository.js';

export const TestEmail = ({ baseUrl, displayName }: TestEmailProps) => (
  <UniversalPhotosLayout preview="This is a test email from UniversalPhotos.">
    <Text className="m-0">
      Hey <strong>{displayName}</strong>!
    </Text>

    <Text>This is a test email from your UniversalPhotos Instance!</Text>

    <Row>
      <Link href={baseUrl}>{baseUrl}</Link>
    </Row>
  </UniversalPhotosLayout>
);

TestEmail.PreviewProps = {
  baseUrl: 'https://demo.',
  displayName: 'Alan Turing',
} as TestEmailProps;

export default TestEmail;
