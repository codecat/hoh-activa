namespace ActiveItems
{
	array<ActiveItemDef@> g_items;

	ActiveItemDef@ GetActiveItem(const string &in id)
	{
		return GetActiveItem(HashString(id));
	}

	ActiveItemDef@ GetActiveItem(uint idHash)
	{
		for (uint i = 0; i < g_items.length(); i++)
		{
			auto item = g_items[i];
			if (item.m_idHash == idHash)
				return item;
		}
		return null;
	}

	void LoadActiveItems(SValue@ sv)
	{
		if (sv.GetType() != SValueType::Array)
		{
			PrintError("Active items sval must be an array!");
			return;
		}

		auto arr = sv.GetArray();
		for (uint i = 0; i < arr.length(); i++)
		{
			auto svItem = arr[i];
			if (svItem.GetType() != SValueType::Dictionary)
			{
				PrintError("Active item sval entry must be a dictionary!");
				continue;
			}

			auto newItemDef = ActiveItemDef(svItem);
			g_items.insertLast(newItemDef);
		}
	}

	ActiveItems::SaveData@ GetLocalSaveData()
	{
		auto record = GetLocalPlayerRecord();
		ActiveItems::SaveData@ saveData;
		if (record.userdata.get("activeitems", @saveData))
			return saveData;
		return null;
	}
}
