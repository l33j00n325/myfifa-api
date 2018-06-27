class ContractsController < APIController
  # load_and_authorize_resource :team
  load_and_authorize_resource :player
  load_and_authorize_resource :contract, through: :player, shallow: true, except: %i[create]

  def index
    render json: @contracts
  end

  def show
    render json: @contract
  end

  def create
    @contract = @player.contracts.new(contract_params)
    save_record @contract
  end

  def update
    @contract.attributes = contract_params
    save_record @contract
  end

  def destroy
    render json: @contract.destroy
  end

  private

    def contract_params
      params.require(:contract).permit Contract.permitted_attributes
    end
end
