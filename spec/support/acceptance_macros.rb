module AcceptanceMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def sign_up(user_attributes)
    visit new_user_registration_path
    fill_in 'Email', with: user_attributes[:email]
    fill_in 'Password', with: user_attributes[:password]
    fill_in 'Password confirmation', with: user_attributes[:password]
    within 'form.new_user' do
      click_on 'Sign up'
    end
  end

  def sign_up_and_confirm(user_attributes)
    clear_emails
    sign_up(user_attributes)

    open_email(user_attributes[:email])

    current_email.click_link 'Confirm my account'

    fill_in 'Email', with: user_attributes[:email]
    fill_in 'Password', with: user_attributes[:password]

    click_on 'Log in'
  end
end
