namespace ActiveItemsHooks
{
	void GiveActiveItemCFunc(cvar_t@ arg0)
	{
		auto player = GetLocalPlayer();
		if (player is null)
			return;

		string id = arg0.GetString();

		ActiveItems::SaveData@ saveData;
		if (!player.m_record.userdata.get("activeitems", @saveData))
		{
			PrintError("Couldn't get active items save data strcture!");
			return;
		}

		saveData.GiveItem(id);
	}

	[Hook]
	void GameModeConstructor(Campaign@ campaign)
	{
		campaign.m_playerMenu.m_tabSystem.AddTab(PLayerInventoryTab(), campaign.m_guiBuilder);

		AddFunction("give_active_item", { cvar_type::String }, GiveActiveItemCFunc, cvar_flags::Cheat);
	}

	[Hook]
	void WidgetHosterLoad(IWidgetHoster@ host, GUIBuilder@ b, GUIDef@ def)
	{
		if (def.GetPath() != "gui/playermenu.gui")
			return;

		// Add the container for our own tab contents
		auto wStats = host.m_widget.GetWidgetById("tab-stats");
		if (wStats is null)
		{
			PrintError("Unable to find \"tab-stats\"!");
			return;
		}
		auto wNewContainer = wStats.Clone();
		wNewContainer.SetID("tab-inventory");
		wStats.m_parent.AddChild(wNewContainer);

		// Add the button to the button list
		auto wTabsClip = host.m_widget.GetWidgetById("tabs-clip");
		auto wNewButton = cast<ScalableSpriteButtonWidget>(wTabsClip.m_children[0].Clone());
		wNewButton.m_value = "inventory";
		wNewButton.m_func = "set-tab inventory";
		wNewButton.SetText("INVENTORY");
		wTabsClip.AddChild(wNewButton);

		// Also let the checkbox group know the button exists so that it will get checked properly
		auto wTabsContainer = cast<CheckBoxGroupWidget>(host.m_widget.GetWidgetById("tabs-container"));
		wTabsContainer.m_checkboxes.insertLast(wNewButton);
	}

	[Hook]
	void LoadWidgetProducers(GUIBuilder@ builder)
	{
		builder.AddWidgetProducer("inventory-button", LoadInventoryButtonWidget);
	}

	[Hook]
	void PlayerRecordSave(PlayerRecord@ record, SValueBuilder &builder)
	{
		ActiveItems::SaveData@ saveData;
		if (record.userdata.get("activeitems", @saveData))
		{
			builder.PushDictionary("activeitems");
			saveData.Save(builder);
			builder.PopDictionary();
		}
	}

	[Hook]
	void PlayerRecordLoad(PlayerRecord@ record, SValue@ sval)
	{
		ActiveItems::SaveData@ saveData;
		if (!record.userdata.get("activeitems", @saveData))
		{
			@saveData = ActiveItems::SaveData(record);
			record.userdata.set("activeitems", @saveData);
		}

		auto svActiveItems = sval.GetDictionaryEntry("activeitems");
		if (svActiveItems !is null)
			saveData.Load(svActiveItems);
	}
}
