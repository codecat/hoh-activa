namespace ActiveItems
{
	class ActiveItemDef
	{
		string m_id;
		uint m_idHash;

		string m_name;
		string m_description;
		ActorItemQuality m_quality;

		ScriptSprite@ m_sprite;

		string m_class;
		SValue@ m_sval;

		ActiveItemDef(SValue@ svItem)
		{
			m_id = GetParamString(UnitPtr(), svItem, "id");
			m_idHash = HashString(m_id);

			m_name = GetParamString(UnitPtr(), svItem, "name");
			m_description = GetParamString(UnitPtr(), svItem, "description");
			m_quality = ParseActorItemQuality(GetParamString(UnitPtr(), svItem, "quality"));

			@m_sprite = ScriptSprite(GetParamArray(UnitPtr(), svItem, "icon"));

			m_class = GetParamString(UnitPtr(), svItem, "class");
			@m_sval = svItem;
		}

		ActiveItem@ Instantiate()
		{
			auto newActiveItem = cast<ActiveItem>(InstantiateClass(m_class, m_sval));
			if (newActiveItem is null)
			{
				PrintError("Unable to instantiate an active item of class \"" + m_class + "\"!");
				return null;
			}
			return newActiveItem;
		}
	}
}
