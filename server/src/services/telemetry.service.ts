import { snakeCase } from 'lodash-es';
import { OnEvent } from 'src/decorators.js';
import { UniversalPhotosWorker, JobStatus } from 'src/enum.js';
import type { ArgOf, ArgsOf } from 'src/repositories/event.repository.js';
import { BaseService } from 'src/services/base.service.js';

export class TelemetryService extends BaseService {
  @OnEvent({ name: 'AppBootstrap', workers: [UniversalPhotosWorker.Api] })
  async onBootstrap(): Promise<void> {
    const userCount = await this.userRepository.getCount();
    this.telemetryRepository.api.addToGauge('universalphotos.users.total', userCount);
  }

  @OnEvent({ name: 'UserCreate' })
  onUserCreate() {
    this.telemetryRepository.api.addToGauge(`universalphotos.users.total`, 1);
  }

  @OnEvent({ name: 'UserTrash' })
  onUserTrash() {
    this.telemetryRepository.api.addToGauge(`universalphotos.users.total`, -1);
  }

  @OnEvent({ name: 'UserRestore' })
  onUserRestore() {
    this.telemetryRepository.api.addToGauge(`universalphotos.users.total`, 1);
  }

  @OnEvent({ name: 'JobStart' })
  onJobStart(...[queueName]: ArgsOf<'JobStart'>) {
    const queueMetric = `universalphotos.queues.${snakeCase(queueName)}.active`;
    this.telemetryRepository.jobs.addToGauge(queueMetric, 1);
  }

  @OnEvent({ name: 'JobSuccess' })
  onJobSuccess({ job, response }: ArgOf<'JobSuccess'>) {
    if (!(response && Object.values(JobStatus).includes(response as JobStatus))) {
      return;
    }

    const jobMetric = `universalphotos.jobs.${snakeCase(job.name)}.${response}`;
    this.telemetryRepository.jobs.addToCounter(jobMetric, 1);
  }

  @OnEvent({ name: 'JobError' })
  onJobError({ job }: ArgOf<'JobError'>) {
    const jobMetric = `universalphotos.jobs.${snakeCase(job.name)}.${JobStatus.Failed}`;
    this.telemetryRepository.jobs.addToCounter(jobMetric, 1);
  }

  @OnEvent({ name: 'JobComplete' })
  onJobComplete(...[queueName]: ArgsOf<'JobComplete'>) {
    const queueMetric = `universalphotos.queues.${snakeCase(queueName)}.active`;
    this.telemetryRepository.jobs.addToGauge(queueMetric, -1);
    this.telemetryRepository.jobs.addToCounter(`universalphotos.queues.${snakeCase(queueName)}.completed`, 1);
  }

  @OnEvent({ name: 'QueueStart' })
  onQueueStart({ name }: ArgOf<'QueueStart'>) {
    this.telemetryRepository.jobs.addToCounter(`universalphotos.queues.${snakeCase(name)}.started`, 1);
  }
}
