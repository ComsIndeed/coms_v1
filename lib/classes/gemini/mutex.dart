import 'dart:async';
import 'dart:collection' show Queue;

/// A simple Mutex implementation to restrict simultaneous accesses to a resource.
class Mutex {
  final Queue<Completer<Lock>> _queue = Queue();

  /// Acquires a lock, returning a `Future<Lock>` that completes when the lock is granted.
  Future<Lock> acquire() {
    final completer = Completer<Lock>();
    _queue.add(completer);
    if (_queue.length == 1) {
      // If no one is holding the lock, grant it immediately.
      completer.complete(Lock._(this));
    }
    return completer.future;
  }

  /// Releases the lock, granting it to the next in line (if any).
  void _release() {
    assert(_queue.isNotEmpty);
    assert(_queue.first.isCompleted);
    _queue.removeFirst();
    if (_queue.isNotEmpty) {
      // Grant the lock to the next in line.
      _queue.first.complete(Lock._(this));
    }
  }
}

/// Represents a lock acquired from `Mutex`.
class Lock {
  Mutex? _mutex;

  Lock._(this._mutex);

  /// Releases the lock. Throws an error if already released.
  void release() {
    final mutex = _mutex;
    if (mutex == null) throw StateError('Lock already released');
    _mutex = null; // Prevent double release
    mutex._release();
  }
}
