import {
  Column,
  CreateDateColumn,
  PrimaryGeneratedColumn,
  Table,
  Timestamp,
  UpdateDateColumn,
  type Generated,
} from '@universal_photos/sql-tools';
import { UpdateIdColumn, UpdatedAtTrigger } from 'src/decorators.js';

@Table('cluster_group')
@UpdatedAtTrigger('cluster_group_updatedAt')
export class ClusterGroupTable {
  @PrimaryGeneratedColumn()
  id!: Generated<string>;

  @Column({ type: 'character varying', nullable: true, default: null })
  name!: string | null;

  @CreateDateColumn()
  createdAt!: Generated<Timestamp>;

  @UpdateDateColumn()
  updatedAt!: Generated<Timestamp>;

  @UpdateIdColumn({ index: true })
  updateId!: Generated<string>;
}
