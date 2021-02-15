# OpenRDS BackRest

##Robust Backup & Restore for Data Services

###Introduction
OpenRDS BackRest aims to be a secure, reliable, easy-to-use backup and restore solution that can seamlessly scale up to the largest databases and workloads by utilizing algorithms that are optimized for database-specific requirements.


## FAQ
### 1.) Is parallel backup & restore supported?
Compression is usually the bottleneck during backup operations but, even with now ubiquitous multi-core servers, most database backup solutions are still single-process. OpenRDS BackRest solves the compression bottleneck with parallel processing.

Utilizing multiple cores for compression makes it possible to achieve 1TB/hr raw throughput even on a 1Gb/s link. More cores and a larger pipe lead to even higher throughput.

### 2.) Are local backups supported?
A custom protocol allows OpenRDS BackRest to backup, restore, and archive locally or remotely via SSH with minimal configuration. An interface to query database is also provided via the protocol layer so that remote access to database is never required, which enhances security.

### 3.) Are incremental & differential backups supported?
Full, differential, and incremental backups are supported. OpenRDS BackRest is not susceptible to the time resolution issues of rsync, making differential and incremental backups completely safe.

### 4.) How does backup rotation & archive expiration work?
Retention polices can be set for full and differential backups to create coverage for any timeframe. WAL archive can be maintained for all backups or strictly for the most recent backups. In the latter case WAL required to make older backups consistent will be maintained in the archive.

### 5.) Can we trust the integrity of the backups?
Checksums are calculated for every file in the backup and rechecked during a restore. After a backup finishes copying files, it waits until every WAL segment required to make the backup consistent reaches the repository.

Backups in the repository are stored in the same format as a standard database cluster (including tablespaces). If compression is disabled and hard links are enabled it is possible to snapshot a backup in the repository and bring up a database cluster directly on the snapshot. 

This is advantageous for terabyte-scale databases that are time consuming to restore in the traditional way.

All operations utilize file and directory level fsync to ensure durability.

### 6.) Are checksums supported?
If page checksums are turned on for a database, OpenRDS BackRest will validate the checksums for every file that is copied during a backup. All page checksums are validated during a full backup and checksums in files that have changed are validated during differential and incremental backups.

Validation failures do not stop the backup process, but warnings with details of exactly which pages have failed validation are output to the console and file log.

This feature allows page-level corruption to be detected early, before backups that contain valid copies of the data have expired.

### 7.) Can a database backup be restarted?
An aborted backup can be resumed from the point where it was stopped. Files that were already copied are compared with the checksums in the manifest to ensure integrity. Since this operation can take place entirely on the backup server, it reduces load on the database server and saves time since checksum calculation is faster than compressing and retransmitting data.

### 8.) Is it efficient?
Compression and checksum calculations are performed in stream while files are being copied to the repository, whether the repository is located locally or remotely.

If the repository is on a backup server, compression is performed on the database server and files are transmitted in a compressed format and simply stored on the backup server. When compression is disabled a lower level of compression is utilized to make efficient use of available bandwidth while keeping CPU cost to a minimum.

### 9.) Do we support delta restore?
The manifest contains checksums for every file in the backup so that during a restore it is possible to use these checksums to speed processing enormously. On a delta restore any files not present in the backup are first removed and then checksums are taken for the remaining files. Files that match the backup are left in place and the rest of the files are restored as usual. Parallel processing can lead to a dramatic reduction in restore times.

### 10.) What about WAL Push & Get features?
Dedicated commands are included for parallel pushing of WAL to the archive and getting WAL from the archive. Both commands support parallelism to accelerate processing and run asynchronously to provide the fastest possible response time to database.

WAL push automatically detects WAL segments that are pushed multiple times and de-duplicates when the segment is identical, otherwise an error is raised. Asynchronous WAL push allows transfer to be offloaded to another process which compresses WAL segments in parallel for maximum throughput. 

This can be a critical feature for databases with extremely high write volume.

Asynchronous WAL get maintains a local queue of WAL segments that are decompressed and ready for replay. This reduces the time needed to provide WAL to database which maximizes replay speed. Higher-latency connections and storage (such as S3) benefit the most.

The push and get commands both ensure that the database and repository match by comparing database versions and system identifiers. This virtually eliminates the possibility of misconfiguring the WAL archive location.

### 11.) Do we support tablespaces & links?
Tablespaces are fully supported and on restore tablespaces can be remapped to any location. It is also possible to remap all tablespaces to one location with a single command which is useful for development restores.

File and directory links are supported for any file or directory in the database cluster. When restoring it is possible to restore all links to their original locations, remap some or all links, or restore some or all links as normal files or directories within the cluster directory.

### 12.) Any suppoprt for Object Store backup & restore?
OpenRDS BackRest repositories can be located in S3 compatible object stores (all public and most private clouds) to allow for virtually unlimited capacity and retention.


### 13.) Are backups encrypted?
Backups are encrypted by default in the repository to secure them wherever they are stored.

