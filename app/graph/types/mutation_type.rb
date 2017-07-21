MutationType = GraphQL::ObjectType.define do
  name 'Mutation'

  # photographer
  field :SignOutPhotographer,          Mutations::Photographer::SignOut.field
  field :UpdatePhotographer,           Mutations::Photographer::Update.field
  field :CreateCalendarItems,          Mutations::Photographer::CreateCalendarItems.field
  field :UploadPhoto,                  Mutations::Photographer::UploadPhoto.field
  field :SyncCalendar,                 Mutations::Photographer::SyncCalendar.field

  # customer
  field :CreateCustomer,               Mutations::Customer::Create.field
  field :UpdateCustomer,               Mutations::Customer::Update.field
  field :SignOutCustomer,              Mutations::Customer::SignOut.field
  field :SendResetPasswordInstruction, Mutations::Customer::SendResetPasswordInstruction.field
  field :ResetPassword,                Mutations::Customer::ResetPassword.field
  field :ContactAdministrator,         Mutations::ContactAdministrator.field
  field :CreateOrder,                  Mutations::Customer::CreateOrder.field
  field :DeleteOrder,                  Mutations::Customer::DeleteOrder.field
  field :ListingOrderDetails,          Mutations::Customer::ListingOrderDetails.field
  field :InitialEmptyOrder,            Mutations::Customer::InitialEmptyOrder.field
  field :ZipcodeValidation,            Mutations::ZipcodeValidation.field
  field :ProductOrderDetails,          Mutations::Customer::ProductOrderDetails.field
  field :ApplyDiscountCode,            Mutations::Customer::ApplyDiscountCode.field
  field :PhotographerOrderDetails,     Mutations::Customer::PhotographerOrderDetails.field
  field :ConfirmPaymentTransaction,    Mutations::Customer::ConfirmPaymentTransaction.field

  # order
  field :UpdateStatus,                 Mutations::Order::UpdateStatus.field

  # company
  field :CreateCompany,                Mutations::Company::Create.field

  # user
  field :SignInUser,                   Mutations::User::SignIn.field
end
