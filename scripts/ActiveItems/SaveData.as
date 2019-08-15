namespace ActiveItems
{
	class SaveData
	{
		PlayerRecord@ m_record;

		array<ActiveItem@> m_items;
		array<ActiveItemDef@> m_hotbar;

		SaveData(PlayerRecord@ record)
		{
			@m_record = record;

			for (uint i = 0; i < 6; i++)
				m_hotbar.insertLast(null);
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

		void TakeItem(ActiveItem@ item, int amount = 1)
		{
			if (amount <= 0)
				return;

			item.m_amount -= amount;
			if (item.m_amount <= 0)
			{
				int index = m_items.findByRef(item);
				if (index != -1)
					m_items.removeAt(index);
			}
		}

		void SetHotbar(int index, ActiveItemDef@ itemDef)
		{
			for (uint i = 0; i < m_hotbar.length(); i++)
			{
				if (m_hotbar[i] is itemDef)
					@m_hotbar[i] = null;
			}
			@m_hotbar[index] = itemDef;
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

			builder.PushArray("hotbar");
			for (uint i = 0; i < m_hotbar.length(); i++)
			{
				auto itemDef = m_hotbar[i];
				if (itemDef is null)
					builder.PushInteger(0);
				else
					builder.PushInteger(int(itemDef.m_idHash));
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

			auto arrHotbar = GetParamArray(UnitPtr(), sv, "hotbar", false);
			if (arrHotbar !is null)
			{
				for (int i = 0; i < min(6, arrHotbar.length()); i++)
				{
					uint idHash = uint(arrHotbar[i].GetInteger());
					if (idHash == 0)
						continue;

					auto itemDef = GetActiveItem(idHash);
					if (itemDef is null)
					{
						PrintError("Unable to find active item definition for ID " + idHash + " for hotbar!");
						continue;
					}

					@m_hotbar[i] = itemDef;
				}
			}
		}
	}
}
