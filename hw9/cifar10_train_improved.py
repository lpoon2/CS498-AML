from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from datetime import datetime
import time, math
import numpy as np
import tensorflow as tf

#things needs
import cifar10_improved_5
MAX_STEPS = 1000000
LOG_FREQ = 100
TRAIN_DIR = 'cifar10_train_improved'
EVAL_DIR = 'cifar10_eval_improved'

FLAGS = tf.app.flags.FLAGS
tf.app.flags.DEFINE_string('train_dir', TRAIN_DIR, """Directory where to write event logs and checkpoint.""")
tf.app.flags.DEFINE_integer('max_steps', MAX_STEPS, """Number of batches to run.""")
tf.app.flags.DEFINE_boolean('log_device_placement', False, """Whether to log device placement.""")
tf.app.flags.DEFINE_integer('log_frequency', LOG_FREQ, """How often to log results to the console.""")

def eval_once(saver, summary_writer, top_k_op, summary_op):
  with tf.Session() as sess:
    ckpt = tf.train.get_checkpoint_state(FLAGS.checkpoint_dir)
    if ckpt and ckpt.model_checkpoint_path:
      saver.restore(sess, ckpt.model_checkpoint_path)
      global_step = ckpt.model_checkpoint_path.split('/')[-1].split('-')[-1]
    else:
      print('No checkpoint file found')
      return

    # Start the queue runners.
    coord = tf.train.Coordinator()
    try:
      threads = []
      for qr in tf.get_collection(tf.GraphKeys.QUEUE_RUNNERS):
        threads.extend(qr.create_threads(sess, coord=coord, daemon=True, start=True))

      num_iter = int(math.ceil(FLAGS.num_examples / FLAGS.batch_size))
      true_count = 0  # Counts the number of correct predictions.
      total_sample_count = num_iter * FLAGS.batch_size
      step = 0
      while step < num_iter and not coord.should_stop():
        predictions = sess.run([top_k_op])
        true_count += np.sum(predictions)
        step += 1

      # Compute precision @ 1.
      precision = true_count / total_sample_count
      print('%s: precision @ 1 = %.3f' % (datetime.now(), precision))

      summary = tf.Summary()
      summary.ParseFromString(sess.run(summary_op))
      summary.value.add(tag='Precision @ 1', simple_value=precision)
      summary_writer.add_summary(summary, global_step)
    except Exception as e:  # pylint: disable=broad-except
      coord.request_stop(e)

    coord.request_stop()
    coord.join(threads, stop_grace_period_secs=10)

def train():
  with tf.Graph().as_default():
    global_step = tf.train.get_or_create_global_step()

    with tf.device('/cpu:0'): images, labels = cifar10_improved_5.distorted_inputs()

    logits = cifar10_improved_5.inference(images)
    loss = cifar10_improved_5.loss(logits, labels)
    train_op = cifar10_improved_5.train(loss, global_step)

    class _LoggerHook(tf.train.SessionRunHook):
      def begin(self):
        self._step = -1
        self._start_time = time.time()

      def before_run(self, run_context):
        self._step += 1
        return tf.train.SessionRunArgs(loss)  # Asks for loss value.

      def after_run(self, run_context, run_values):
        if self._step % FLAGS.log_frequency == 0:
          current_time = time.time()
          duration = current_time - self._start_time
          self._start_time = current_time

          loss_value = run_values.results
          examples_per_sec = FLAGS.log_frequency * FLAGS.batch_size / duration
          sec_per_batch = float(duration / FLAGS.log_frequency)

          format_str = ('%s: step %d, loss = %.2f (%.1f examples/sec; %.3f sec/batch)')
          print (format_str % (datetime.now(), self._step, loss_value, examples_per_sec, sec_per_batch))

    with tf.train.MonitoredTrainingSession(
        checkpoint_dir=FLAGS.train_dir,
        hooks=[tf.train.StopAtStepHook(last_step=FLAGS.max_steps),
               tf.train.NanTensorHook(loss),
               _LoggerHook()],
        config=tf.ConfigProto(log_device_placement=FLAGS.log_device_placement),
        save_checkpoint_secs=5,
        save_summaries_steps=100
    ) as mon_sess:
      while not mon_sess.should_stop():
        mon_sess.run(train_op)

def main(argv=None):  # pylint: disable=unused-argument
  cifar10_improved_5.maybe_download_and_extract()
  if tf.gfile.Exists(FLAGS.train_dir):
    tf.gfile.DeleteRecursively(FLAGS.train_dir)
  tf.gfile.MakeDirs(FLAGS.train_dir)
  train()

if __name__ == '__main__':
  tf.app.run()
