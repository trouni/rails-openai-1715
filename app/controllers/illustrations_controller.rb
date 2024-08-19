class IllustrationsController < ApplicationController

  # POST characters/:character_id/illustrations
  def create
    # Find the character
    character = Character.find(params[:character_id])
    situation = params[:situation]
    # Create an illustration using OpenAI DALL-E
    prompt = GeneratePrompt.new(character.description, situation).call
    image_url = GenerateIllustration.new(prompt).call
    # Attach the generate illustration to the Character instance
    character.attach_illustration_from_url(image_url)

    # Redirect to character show page
    redirect_to character_path(character)
  end

  def destroy
    @illustration = ActiveStorage::Attachment.find(params[:id])
    @character = @illustration.record
    @illustration.purge
    redirect_to character_path(@character), notice: 'The illustration has been deleted!'
  end
end
