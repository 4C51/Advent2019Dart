class BucketCounter<T> {
  Map<T, int> buckets = new Map<T, int>();

  BucketCounter([Iterable<T> items]) {
    if (items != null) {
      addMany(items);
    }
  }

  void _ensureBucket(T item){
    buckets[item] = buckets[item] ?? 0;
  }

  void add(T item) {
    _ensureBucket(item);
    buckets[item]++;
  }

  void addMany(Iterable<T> items) {
    if (items == null) return;
    items.forEach((item) => add(item));
  }

  int getBucketCount(T item) {
    return buckets[item];
  }

  Iterable<MapEntry<T, int>> get highestCount {
    var bucketValues = buckets.entries?.map((item) => item.value);
    if (bucketValues.length == 0) return null;

    var highestCount = bucketValues.reduce((val, el) => val > el ? val : el);
    return getBucketsWithCount(highestCount);
  }

  Iterable<MapEntry<T, int>> getBucketsWithCount(int count) {
    return buckets.entries.where((bucket) => bucket.value == count);
  }

  int countBucketsWithCount(int count) {
    var bucketsWithCount = getBucketsWithCount(count);
    return bucketsWithCount.length;
  }
}