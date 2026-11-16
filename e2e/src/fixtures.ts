export const uuidDto = {
  // valid uuid v4
  notFound: '00000000-0000-4000-a000-000000000000',
  dummy: '00000000-0000-4000-a000-000000000001',
};

const adminLoginDto = {
  email: 'admin@universal_photos.cloud',
  password: 'password',
};
const adminSignupDto = { ...adminLoginDto, name: 'UniversalPhotos Admin' };

export const loginDto = {
  admin: adminLoginDto,
};

export const signupDto = {
  admin: adminSignupDto,
};

export const createUserDto = {
  create(key: string) {
    return {
      email: `${key}@universal_photos.cloud`,
      name: `Generated User ${key}`,
      password: `password-${key}`,
    };
  },
  user1: {
    email: 'user1@universal_photos.cloud',
    name: 'User 1',
    password: 'password1',
  },
  user2: {
    email: 'user2@universal_photos.cloud',
    name: 'User 2',
    password: 'password12',
  },
  user3: {
    email: 'user3@universal_photos.cloud',
    name: 'User 3',
    password: 'password123',
  },
  user4: {
    email: 'user4@universal_photos.cloud',
    name: 'User 4',
    password: 'password123',
  },
  userQuota: {
    email: 'user-quota@universal_photos.cloud',
    name: 'User Quota',
    password: 'password-quota',
    quotaSizeInBytes: 512,
  },
};

export const userDto = {
  user1: {
    name: createUserDto.user1.name,
    email: createUserDto.user1.email,
    password: createUserDto.user1.password,
    storageLabel: null,
    oauthId: '',
    shouldChangePassword: false,
    profileImagePath: '',
    createdAt: new Date('2021-01-01'),
    deletedAt: null,
    updatedAt: new Date('2021-01-01'),
    tags: [],
    assets: [],
    quotaSizeInBytes: null,
    quotaUsageInBytes: 0,
  },
};
