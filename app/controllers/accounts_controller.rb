class AccountsController < ApplicationController
  def new
    @persona = ensure_persona!
    redirect_to edit_my_persona_path, notice: "Account already claimed. One identity crisis at a time." if @persona.claimed?
  end

  def create
    @persona = ensure_persona!
    return redirect_to edit_my_persona_path if @persona.claimed?

    attrs = params.require(:persona).permit(:name, :email, :password)
    attrs[:password] = nil if attrs[:password].blank?
    if attrs[:email].present? && attrs[:password].nil?
      @persona.errors.add(:password, "is required to claim an account")
      flash.now[:alert] = @persona.errors.full_messages.first
      return render :new, status: :unprocessable_entity
    end

    if @persona.update(attrs)
      redirect_to root_path, notice: "Account claimed as #{@persona.name}. No verification email. We trust you, which is our first mistake."
    else
      flash.now[:alert] = @persona.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end
end
