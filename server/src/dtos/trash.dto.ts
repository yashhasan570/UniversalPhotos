import { createZodDto } from '@universal_photos/nestjs-standard-schema/zod';
import z from 'zod';

export class TrashResponseDto extends createZodDto({
  count: z.int().describe('Number of items in trash'),
}) {}
