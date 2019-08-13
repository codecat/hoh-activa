class PLayerInventoryTab : PlayerMenuTab
{
	ScrollableWidget@ m_wItemList;
	Widget@ m_wItemTemplate;

	PLayerInventoryTab()
	{
		m_id = "inventory";
	}

	void OnCreated() override
	{
		@m_wItemList = cast<ScrollableWidget>(m_widget.GetWidgetById("list-items"));
		@m_wItemTemplate = m_widget.GetWidgetById("template-item");
	}

	void OnShow() override
	{
		ReloadList();
	}

	void ReloadList()
	{
		auto saveData = ActiveItems::GetLocalSaveData();

		m_wItemList.PauseScrolling();
		m_wItemList.ClearChildren();

		for (uint i = 0; i < saveData.m_items.length(); i++)
		{
			auto item = saveData.m_items[i];
			auto itemDef = item.m_def;

			auto wNewItem = cast<InventoryButton>(m_wItemTemplate.Clone());
			wNewItem.SetID("");
			wNewItem.m_visible = true;

			wNewItem.SetItem(item);
			wNewItem.m_func = "use-item " + itemDef.m_id;

			m_wItemList.AddChild(wNewItem);
		}

		m_wItemList.ResumeScrolling();

		m_widget.m_host.m_forceFocus = true;
	}

	bool OnFunc(Widget@ sender, string name) override
	{
		auto parse = name.split(" ");
		if (parse[0] == "use-item")
		{
			string itemId = parse[1];
			auto saveData = ActiveItems::GetLocalSaveData();
			auto item = saveData.GetItem(itemId);
			if (item is null)
			{
				PrintError("Item with ID \"" + itemId + "\" is not in inventory!");
				return true;
			}

			auto player = GetLocalPlayer();
			if (!item.CanUse(player))
			{
				PrintError("Item with ID \"" + itemId + "\" can not be used right now!");
				return true;
			}

			if (!item.Use(player))
			{
				PrintError("Using item with ID \"" + itemId + "\" didn't work!");
				return true;
			}

			saveData.TakeItem(item);

			ReloadList();
			return true;
		}
		return false;
	}
}
