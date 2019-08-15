namespace ActiveItems
{
	class EffectItem : ActiveItem
	{
		array<IEffect@>@ m_effects;

		EffectItem(SValue& params)
		{
			super(params);

			@m_effects = LoadEffects(UnitPtr(), params);
		}

		bool CanUse(Player@ player) override
		{
			return CanApplyEffects(m_effects, player, player.m_unit, vec2(), vec2(), 1.0f);
		}

		bool Use(Player@ player) override
		{
			return ApplyEffects(m_effects, player, player.m_unit, vec2(), vec2(), 1.0f, false);
		}

		void NetUse(PlayerHusk@ player) override
		{
			ApplyEffects(m_effects, player, player.m_unit, vec2(), vec2(), 1.0f, true);
		}
	}
}
