#!/bin/bash
# Validate Conductor setup and file structure

set -e

echo "🔍 Validating Conductor setup..."

# Check if conductor directory exists
if [ ! -d "conductor" ]; then
    echo "❌ conductor/ directory not found"
    echo "   Run /claude-conductor:setup to initialize"
    exit 1
fi

# Check required files
REQUIRED_FILES=(
    "conductor/product.md"
    "conductor/tech-stack.md"
    "conductor/workflow.md"
    "conductor/tracks.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Missing: $file"
        exit 1
    fi
done

echo "✅ All required files present"

# Validate tracks.md format
if ! grep -q "# Conductor Tracks" conductor/tracks.md; then
    echo "⚠️  tracks.md missing header"
fi

# Check for track directories
TRACK_COUNT=$(find conductor/tracks -maxdepth 1 -type d -name "track_*" 2>/dev/null | wc -l)
echo "📊 Found $TRACK_COUNT track(s)"

# Validate each track
for track_dir in conductor/tracks/track_*/ 2>/dev/null; do
    if [ -d "$track_dir" ]; then
        track_id=$(basename "$track_dir")
        echo "  Checking $track_id..."

        [ -f "${track_dir}spec.md" ] || echo "    ⚠️  Missing spec.md"
        [ -f "${track_dir}plan.md" ] || echo "    ⚠️  Missing plan.md"
        [ -f "${track_dir}metadata.json" ] || echo "    ⚠️  Missing metadata.json"
    fi
done

echo "✅ Conductor validation complete"
