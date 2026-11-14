import * as React from 'react';
import { Link, Section, Text } from 'react-email';
import { UniversalPhotosButton } from 'src/emails/components/button.component.js';
import FutoLayout from 'src/emails/components/futo.layout.js';

/**
 * Template to be used for FUTOPay project
 * Variable is {{LICENSEKEY}}
 * */
export const LicenseEmail = () => (
  <FutoLayout preview="Your UniversalPhotos Server License">
    <Text>Thank you for supporting UniversalPhotos and open-source software</Text>

    <Text>
      Your <strong>UniversalPhotos</strong> key is
    </Text>

    <Section className="my-2 bg-gray-200 rounded-2xl text-center p-4">
      <Text className="m-0 text-monospace font-bold text-universalphotos-primary">{'{{LICENSEKEY}}'}</Text>
    </Section>

    <Text>
      To activate your instance, you can click the following button or copy and paste the link below to your browser.
    </Text>

    <Section className="flex justify-center my-6">
      <UniversalPhotosButton
        href={`https://my./link?target=activate_license&licenseKey={{LICENSEKEY}}&activationKey={{ACTIVATIONKEY}}`}
      >
        Activate
      </UniversalPhotosButton>
    </Section>

    <Text className="text-center">
      <Link
        className="text-universalphotos-primary text-sm"
        // style={{ marginTop: '50px', color: 'rgb(66, 80, 175)', fontSize: '0.9rem' }}
        href={`https://my./link?target=activate_license&licenseKey={{LICENSEKEY}}&activationKey={{ACTIVATIONKEY}}`}
      >
        https://my./link?target=activate_license&licenseKey={'{{LICENSEKEY}}'}&activationKey=
        {'{{ACTIVATIONKEY}}'}
      </Link>
    </Text>
  </FutoLayout>
);

LicenseEmail.PreviewProps = {};

export default LicenseEmail;
