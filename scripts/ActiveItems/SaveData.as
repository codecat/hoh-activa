namespace ActiveItems
{
	class SaveData
	{
		PlayerRecord@ m_record;

		array<ActiveItem@> m_items;

		SaveData(PlayerRecord@ record)
		{
			@m_record = record;
		}

		ActiveItem@ GetItem(const string &in id)
		{
			return GetItem(HashString(id));
		}

		ActiveItem@ GetItem(uint idHash)
		{
			for (uint i = 0; i < m_items.length(); i++)
			{
				auto item = m_items[i];
				if (item.m_def.m_idHash == idHash)
					return item;
			}
			return null;
		}

		void GiveItem(const string &in id, int amount = 1)
		{
			GiveItem(HashString(id), amount);
		}

		void GiveItem(uint idHash, int amount = 1)
		{
			auto itemDef = GetActiveItem(idHash);
			if (itemDef is null)
			{
				PrintError("Unable to give item with hash " + idHash + ", it was not found!");
				return;
			}
			GiveItem(itemDef, amount);
		}

		void GiveItem(ActiveItemDef@ def, int amount = 1)
		{
			if (amount <= 0)
				return;

			auto item = GetItem(def.m_idHash);
			if (item is null)
			{
				@item = def.Instantiate();
				m_items.insertLast(item);
				item.OnCreated(def);
			}

			item.m_amount += amount;
			item.OnGiven(m_record, amount);
		}

		void Save(SValueBuilder@ builder)
		{
			builder.PushArray("items");
			for (uint i = 0; i < m_items.length(); i++)
			{
				builder.PushDictionary();
				m_items[i].Save(builder);
				builder.PopDictionary();
			}
			builder.PopArray();
		}

		void Load(SValue@ sv)
		{
			auto arrItems = GetParamArray(UnitPtr(), sv, "items", false);
			if (arrItems !is null)
			{
				for (uint i = 0; i < arrItems.length(); i++)
				{
					auto svItem = arrItems[i];

					string id = GetParamString(UnitPtr(), svItem, "id");
					auto itemDef = GetActiveItem(id);
					if (itemDef is null)
					{
						PrintError("Unable to find active item definition for ID \"" + id + "\"!");
						continue;
					}

					GiveItem(itemDef);
				}
			}
		}
	}
}
