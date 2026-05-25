import sys
import argparse
import pysam


def main():
    parser = argparse.ArgumentParser(
        description="Introduce a synthetic deletion in reads (BAM → FASTQ)"
    )
    parser.add_argument("--input", required=True, help="Input BAM file")
    parser.add_argument(
        "--start",
        type=int,
        required=True,
        help="Deletion start (0-based, inclusive)"
    )
    parser.add_argument(
        "--end",
        type=int,
        required=True,
        help="Deletion end (0-based, exclusive)"
    )
    parser.add_argument(
        "--contig",
        default="chrM",
        help="Reference contig (default: chrM)"
    )

    args = parser.parse_args()

    if args.start >= args.end:
        raise ValueError("start must be < end")

    in_bam = pysam.AlignmentFile(args.input, "rb")
    out = sys.stdout

    for read in in_bam.fetch(args.contig):

        if read.is_unmapped:
            continue

        seq = read.query_sequence
        qual = read.qual

        if seq is None or qual is None:
            continue

        ref_pos = read.reference_start
        read_end = read.reference_end

        # Extract RG tag if present
        rg = read.get_tag("RG") if read.has_tag("RG") else "NA"

        # Preserve original FASTQ suffixes for paired reads
        if read.is_read1:
            read_suffix = "/1"
        elif read.is_read2:
            read_suffix = "/2"
        else:
            read_suffix = ""

        # Add RG into FASTQ header
        header = f"{read.query_name}{read_suffix} RG:Z:{rg}"

        # no overlap → passthrough
        if read_end < args.start or ref_pos > args.end:
            out.write(f"@{header}\n{seq}\n+\n{qual}\n")
            continue

        # overlap → splice out deletion
        left = max(0, args.start - ref_pos)
        right = max(0, read_end - args.end)

        if right > 0:
            new_seq = seq[:left] + seq[-right:]
            new_qual = qual[:left] + qual[-right:]
        else:
            new_seq = seq[:left]
            new_qual = qual[:left]

        out.write(f"@{header}\n{new_seq}\n+\n{new_qual}\n")

    in_bam.close()


if __name__ == "__main__":
    main()