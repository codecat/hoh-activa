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
		auto record = GetLocalPlayerRecord();

		ActiveItems::SaveData@ saveData;
		if (!record.userdata.get("activeitems", @saveData))
		{
			PrintError("Unable to get active item save data!");
			return;
		}

		m_wItemList.PauseScrolling();
		m_wItemList.ClearChildren();

		for (uint i = 0; i < saveData.m_items.length(); i++)
		{
			auto item = saveData.m_items[i];

			auto wNewItem = cast<InventoryButton>(m_wItemTemplate.Clone());
			wNewItem.SetID("");
			wNewItem.m_visible = true;

			wNewItem.SetItem(item);

			m_wItemList.AddChild(wNewItem);
		}

		m_wItemList.ResumeScrolling();
	}

	bool OnFunc(Widget@ sender, string name) override
	{
		print("Inventory func: \"" + name + "\"");
		// Return true if func was handled, otherwise return false
		return false;
	}
}
