class ClearTaskChainPosition < ActiveRecord::Migration
  def change
    Task.where(chain_id: nil).update_all(chain_position: nil)
  end
end
