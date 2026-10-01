#!/data/data/com.termux/files/usr/bin/sh
# Organize X Media Downloader files on Android.
# Files like account_2024-01-01_123_1.jpg go into ./account/
#
# Usage (in Termux):
#   cd ~/storage/downloads    # or ~/storage/shared/Download
#   sh organize-android.sh
#   # or: sh organize-android.sh /path/to/folder

set -e

DIR="${1:-.}"
cd -- "$DIR" || {
  echo "Cannot open folder: $DIR"
  exit 1
}

echo "Working in: $(pwd)"
echo "Scanning…"

moved=0
skipped=0

for f in *; do
  [ -e "$f" ] || continue
  [ -f "$f" ] || continue

  case "$f" in
    *_*)
      acct="${f%%_*}"
      # skip junk / already-organized looking names
      case "$acct" in
        ""|*.*|album) skipped=$((skipped + 1)); continue ;;
      esac
      # account handles are letters/digits/underscore
      case "$acct" in
        *[!A-Za-z0-9_]*) skipped=$((skipped + 1)); continue ;;
      esac

      mkdir -p -- "$acct"
      if mv -n -- "$f" "$acct/" 2>/dev/null; then
        moved=$((moved + 1))
      else
        skipped=$((skipped + 1))
      fi
      ;;
    *)
      skipped=$((skipped + 1))
      ;;
  esac
done

echo "Done. Moved: $moved  Skipped: $skipped"
echo "Open each account folder and tap album.html with a file manager (not Chrome Downloads preview)."
