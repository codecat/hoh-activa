class HotbarItemWidget : RectWidget
{
	int m_hotbarIndex = -1;

	//NOTE: Can be null!
	ActiveItems::ActiveItem@ m_item;

	TextWidget@ m_wAmount;

	HotbarItemWidget()
	{
		super();
	}

	Widget@ Clone() override
	{
		HotbarItemWidget@ w = HotbarItemWidget();
		CloneInto(w);
		return w;
	}

	void RefreshItemData()
	{
		if (m_wAmount !is null)
		{
			m_wAmount.m_visible = (m_item !is null);
			if (m_item !is null)
				m_wAmount.SetText(formatThousands(m_item.m_amount));
		}
	}

	void Update(int dt) override
	{
		RefreshItemData();

		RectWidget::Update(dt);
	}

	void SetHotbarIndex(int index)
	{
		m_hotbarIndex = index;

		@m_wAmount = cast<TextWidget>(GetWidgetById("amount"));
	}

	void Load(WidgetLoadingContext &ctx) override
	{
		RectWidget::Load(ctx);

		m_canFocus = true;
	}
}

ref@ LoadHotbarItemWidget(WidgetLoadingContext &ctx)
{
	HotbarItemWidget@ w = HotbarItemWidget();
	w.Load(ctx);
	return w;
}
