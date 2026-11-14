import * as React from 'react';
import { Body, Container, Font, Head, Hr, Html, Img, Preview, Section, Tailwind, Text } from 'react-email';
// @ts-expect-error
import tailwindPresetEmail from 'tailwindcss-preset-email';
import { UniversalPhotosFooter } from 'src/emails/components/footer.template.js';

interface UniversalPhotosLayoutProps {
  children: React.ReactNode;
  preview: string;
}

export const UniversalPhotosLayout = ({ children, preview }: UniversalPhotosLayoutProps) => (
  <Html>
    <Tailwind
      config={{
        presets: [tailwindPresetEmail],
        theme: {
          extend: {
            colors: {
              // Light Theme
              'universalphotos-primary': '#4250AF',
              'universalphotos-bg': 'white',
              'universalphotos-fg': 'black',
              'universalphotos-gray': '#F6F6F4',
              'universalphotos-footer': '#6A737D',
            },
            fontFamily: {
              sans: ['Overpass', 'sans-serif'],
              mono: ['Overpass Mono', 'monospace'],
            },
          },
        },
      }}
    >
      <Head>
        <Font
          fontFamily="Overpass"
          fallbackFontFamily="sans-serif"
          webFont={{
            url: 'https://fonts.gstatic.com/s/overpass/v13/qFdH35WCmI96Ajtm81GrU9vyww.woff2',
            format: 'woff2',
          }}
          fontWeight={'100 900'}
          fontStyle="normal"
        />
      </Head>
      <Preview>{preview}</Preview>
      <Body className="bg-[#F4F4f4] my-auto mx-auto px-2 font-sans text-base text-gray-800">
        <Container className="my-[40px] mx-auto max-w-[465px]">
          <Section className="my-6 p-12 border border-red-400 rounded-[50px] bg-gray-50">
            <Section className="flex justify-center mb-12">
              <Img
                src="https:///img/universalphotos-logo-inline-light.png"
                className="h-12 antialiased rounded-none w-full"
                alt="UniversalPhotos"
              />
            </Section>

            {children}
          </Section>

          <Hr className="my-2 text-universalphotos-gray" />

          <UniversalPhotosFooter />
        </Container>
      </Body>
    </Tailwind>
  </Html>
);

UniversalPhotosLayout.PreviewProps = {
  preview: 'This is the preview shown on some mail clients',
  children: <Text>Email body goes here.</Text>,
} as UniversalPhotosLayoutProps;

export default UniversalPhotosLayout;
