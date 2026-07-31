class RemapReactionKinds < ActiveRecord::Migration[8.1]
  MAPPING = {
    "inspiring" => "aura_farming",
    "congrats" => "labubu",
    "insightful" => "aura_farming",
    "cap" => "larp_sahur",
    "gym" => "labubu"
  }.freeze

  def up
    MAPPING.each do |old_kind, new_kind|
      execute <<~SQL
        UPDATE reactions SET kind = '#{new_kind}'
        WHERE kind = '#{old_kind}'
          AND NOT EXISTS (
            SELECT 1 FROM reactions AS dup
            WHERE dup.post_id = reactions.post_id
              AND dup.persona_id = reactions.persona_id
              AND dup.kind = '#{new_kind}'
          )
      SQL
      execute "DELETE FROM reactions WHERE kind = '#{old_kind}'"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
