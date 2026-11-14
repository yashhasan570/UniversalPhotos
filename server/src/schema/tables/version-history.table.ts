import { Column, CreateDateColumn, PrimaryGeneratedColumn, Table, Timestamp, type Generated } from '@universalphotos/sql-tools';

@Table('version_history')
export class VersionHistoryTable {
  @PrimaryGeneratedColumn()
  id!: Generated<string>;

  @CreateDateColumn()
  createdAt!: Generated<Timestamp>;

  @Column()
  version!: string;
}
