from pathlib import Path

from tools.pytest_shard import INTEGRATION, inventory, partition


def test_native_integration_and_shards_cover_the_complete_inventory_once():
    files = inventory(Path(__file__).resolve().parents[1])
    integration = [f for f in files if f in INTEGRATION]
    shards = partition([f for f in files if f not in INTEGRATION], 32)
    combined = integration + [f for shard in shards for f in shard]
    assert sorted(combined) == files
    assert len(combined) == len(set(combined))
    assert set(integration) == INTEGRATION
    assert all(shards)
