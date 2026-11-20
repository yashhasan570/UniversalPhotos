import { createZodDto } from '@universal_photos/nestjs-standard-schema/zod';
import { ManualJobNameSchema } from 'src/enum.js';

export class JobCreateDto extends createZodDto({
  name: ManualJobNameSchema,
}) {}
