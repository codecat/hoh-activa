class HotbarItemWidget : RectWidget
{
	int m_hotbarIndex = -1;

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
