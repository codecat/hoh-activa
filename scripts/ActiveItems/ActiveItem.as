namespace ActiveItems
{
	class ActiveItem
	{
		ActiveItemDef@ m_def;

		int m_amount;

		ActiveItem(SValue& params)
		{
		}

		void OnCreated(ActiveItemDef@ def)
		{
			@m_def = def;
		}

		void OnGiven(PlayerRecord@ player, int amount) {}

		void Save(SValueBuilder@ builder)
		{
			builder.PushString("id", m_def.m_id);
			builder.PushInteger("amount", m_amount);
		}

		void Load(SValue@ sv)
		{
			m_amount = GetParamInt(UnitPtr(), sv, "amount", false, 1);
		}

		bool CanUse(Player@ player) { return false; }
		bool Use(Player@ player) { return false; }
		void NetUse(PlayerHusk@ player) {}
	}
}
