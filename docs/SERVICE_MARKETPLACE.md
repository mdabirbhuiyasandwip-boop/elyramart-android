# Elyramart Marketplace Scope

Elyramart is planned as a combined product marketplace and local-services marketplace.

## Customer app
- Browse products by category, search, view product details, add to cart, and place orders.
- Browse services and request a technician visit.
- Choose service category, describe the problem, add photos, enter address, select a preferred date/time, and submit a booking request.
- View booking status: requested, accepted, technician assigned, on the way, in progress, completed, or cancelled.
- Contact support and view order/booking history.

## Technician / service-provider categories
- Electrician and home electrical repair
- Plumber and sanitary / pipe repair
- AC installation and servicing
- Refrigerator and washing-machine repair
- Computer and laptop repair
- Mobile phone repair
- IPS, inverter and generator servicing
- TV and home-appliance repair
- General home maintenance

## Provider onboarding
- Provider registration and profile
- Name, phone, service categories, service area, experience, working hours and profile photo
- Admin review/approval before appearing publicly
- Ability to accept or reject incoming service requests
- Booking history and status updates

## Admin controls
- Review and approve/reject providers
- Manage service categories and service areas
- View customer requests and assign/reassign technicians
- Manage bookings, complaints and cancellations
- Configure visit charges/commission and payment status

## Important implementation notes
- Customer must see the estimated visit fee or be told that the provider will quote after inspection before confirming.
- Do not advertise providers as verified until admin has checked their identity/credentials.
- Do not collect or store sensitive payment credentials.
- Keep product orders and service bookings as separate flows in the app.
- Actual live booking, payment settlement, notifications and provider verification require backend integration and testing; this document is the agreed product scope, not proof those features are already implemented.
