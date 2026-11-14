# Elyramart — Product Requirements & Delivery Plan

## Product goal
Build Elyramart as a Bangladesh-first, multi-vendor marketplace and local-services platform. Android is the first release target. The web admin panel and public website follow after the Android app is stable. The first release must be a real, testable product—not a static demo. Do not enable paid services or payment collection without the owner's explicit approval and required credentials.

## Brand and ownership
- Product name: Elyramart.
- Use the original Elyramart short logo: the stylized “E” symbol only in app branding/creative assets.
- Owner account: elyramartbd@gmail.com. Keep owner administration separate from customer/vendor access; never expose admin navigation or admin data to ordinary users.
- Android application ID: com.elyramartbd.elyramart.
- Support Bengali and English initially; architect language resources so additional languages can be added. Do not claim every world language is translated until translations exist.

## Roles and permissions
- Guest: browse public listings and services; prompt for sign-in only for protected actions.
- Customer: manage profile/addresses, wishlist, cart, orders, bookings, reviews, support requests and notifications.
- Seller/shop: apply, submit required details, await owner approval, manage own products, inventory, prices and orders.
- Property lister/owner: create and manage own rental listings; contact details visible according to privacy settings.
- Technician/service provider: apply, submit skills/coverage/charges, await approval, manage availability and assigned bookings.
- Delivery agent: see only assigned deliveries and update permitted delivery statuses.
- Owner admin: private, verified owner-only access to users, sellers, technicians, listings, products, categories, orders, bookings, reviews, support, settings and audit logs. Enforce authorization in backend security rules/API, not merely by hiding UI.

## 1. Product marketplace
- Categories, subcategories and category browsing.
- Search with useful filters and sorting (category, price, brand, condition, availability, location where relevant).
- Product details: multiple photos, title, price, description, brand, condition, stock, seller, rating/reviews.
- Wishlist, cart, checkout, order history and order tracking.
- Seller product submission and owner approval/moderation.
- Inventory and order status management.
- Reviews and ratings restricted to eligible customers.
- Flash sales, offers, coupon/discount support and promotional banners.
- Product examples/categories may include electronics, computers, accessories, printers, CCTV, networking, components, office equipment, software, groceries, cosmetics, medicines where legally permitted, clothing and other approved goods. Categories must be owner-configurable.

## 2. Rental marketplace
- Dedicated rental search integrated with the main search/home discovery.
- House/flat, room, office, shop/commercial space and other owner-approved rental types.
- Listing fields: title, property type, rent/price, location, description, photos, availability, contact details and lister ID.
- Search by area, title, property type and price; filters and sorting.
- Create, edit and delete own listings; owner admin can review, approve, suspend or remove any listing.
- Contact lister and safety reminders to verify property and documents before payment/commitment.
- Rental listings must be included in global search results where relevant.

## 3. Services and technicians
- Service directory with categories such as AC, computer, laptop, printer, CCTV, networking, electrical, plumbing/sanitary and other approved home/business services.
- Search providers by service and service area/location.
- Provider profile: skills, experience/details, coverage area, service charge, availability, rating and reviews.
- Technician application and owner approval workflow.
- Service booking with selected service/provider, date, time, address, notes and confirmation.
- Booking status lifecycle: requested, accepted, scheduled, on-the-way, in-progress, completed, cancelled/rebooked.
- Technician/customer communication and status updates.
- Live location tracking only when the provider explicitly shares location and the required permissions/backend are configured; otherwise show status and map/address without pretending to have live GPS.

## 3A. Travel, tolls and accommodation
- **Toll payments:** provide a toll-road/bridge directory, eligible vehicle details, official operator selection, fee display from an authoritative current source, payment through the operator's approved channel, and a verifiable receipt/reference. Never collect toll money or claim a toll is paid until an official operator/payment-gateway integration confirms settlement. No stored vehicle plate or travel history without user consent.
- **Launch/ferry tickets:** search routes, terminals, operator, departure date/time, seat/class and passenger count; show only provider-confirmed schedules and availability; submit booking to an authorized operator/aggregator; issue provider-confirmed ticket/PNR and cancellation/refund terms. No invented schedule, seat availability or ticket.
- **Hotel booking:** search destination, check-in/check-out, guest/room count, room type and amenities; show total price, taxes, cancellation policy and provider; confirm only after live availability and provider confirmation. Protect guest details and never expose them in public listings.
- **House/flat rental:** retain the rental marketplace, with area, budget, property type, lease duration, move-in date, owner verification and visit scheduling. A listing/contact request is not a confirmed tenancy; deposits and rent must not be collected until safe, verified payment/contract workflows exist.
- Shared travel/accommodation booking history, request status, support/dispute handling and receipts; clearly distinguish enquiry, pending provider confirmation, confirmed, cancelled and refunded states.
- Provider onboarding must verify identity, business authority, route/property inventory and service terms. Integrate only official or contract-authorized provider APIs; respect licensing and local transport/accommodation rules.
- **Release gate:** these services may appear as "coming soon" or enquiry-only until live provider contracts/APIs, settlement callbacks, security rules and end-to-end tests are in place. No mock bookings, simulated toll payment, fabricated hotel inventory or fake tickets.

## 4. Booking management
- Select date/time and address; validate availability before confirmation.
- Booking ID, customer/provider details, notes, price estimate and status history.
- Cancel/rebook rules and notifications.
- Owner admin can view and manage bookings with audit history.

## 5. Chat and notifications
- In-app customer-to-seller/provider chat with access limited to conversation participants and authorized admins.
- Push notifications for order, booking, status, account and support updates.
- Promotional notifications must be opt-in and owner-manageable.
- Use Firebase Cloud Messaging only after Firebase project configuration is complete.

## 6. Payments
- Planned methods: bKash, Nagad, Rocket, Visa/Mastercard via an approved payment gateway such as SSLCommerz, plus Cash on Delivery where supported.
- Payment integrations remain disabled until the owner approves the provider, supplies merchant credentials, and the integration is tested. Never store raw card details.
- Record payment status, transaction reference and refunds safely; do not mark an order paid based only on a client-side success screen.

## 7. Profile and settings
- Profile management, address book, password/account security, language selection and privacy settings.
- Secure sign-in and recovery; support verified email and/or phone OTP where configured.
- Social sign-in only after provider configuration and testing.
- Users can manage their own data; admin permissions are separate.

## 8. Support
- Help centre, FAQ, support tickets/complaints and ticket status.
- Live support is a future capability requiring staffed coverage and an actual chat provider; do not advertise 24/7 until staffed and operational.

## 9. Everyday-life and future-ready services
These are planned modules, not claims that they are already live. Build them in stages after the core marketplace is stable; each module must have real providers/data, clear operating responsibility and owner moderation.
- **Health access:** searchable verified hospital, clinic, pharmacy, diagnostic-centre and blood-donor directory; emergency contact shortcuts. Do not diagnose, prescribe, promise ambulance availability or expose donor/patient personal data. Emergency guidance must clearly direct users to official emergency services.
- **Transport and mobility:** local transport/rent-a-vehicle contacts, parcel/courier options and accessible route information where reliable providers/data exist. Do not claim live vehicle tracking without a working opt-in location service.
- **Jobs and earning:** job listings, part-time/gig work, employer profiles, skill training and application tracking; report scams, prohibit upfront recruitment fees and moderate employers.
- **Education and growth:** tutors, coaching, courses, learning resources, exam preparation and skill-development listings; verify claims and clearly label paid courses.
- **Home and family support:** cleaning, laundry, home shifting, childcare/elder-care provider directories and repair services. Sensitive care providers require stronger verification, references and clear safety/reporting procedures.
- **Community essentials:** blood donation requests, lost-and-found, community help, disaster/weather alerts and verified relief information. Keep location sharing optional and prevent public exposure of private addresses.
- **Daily planning tools:** reminders for bills/appointments, saved addresses, order and booking history, reusable shopping lists and service schedules. Reminders are opt-in and can be turned off.
- **Accessibility and inclusion:** readable text, screen-reader labels, clear contrast, simple Bengali-first navigation, low-data mode, graceful offline/error states and support for older or less technical users.
- **Trust and safety:** verified badges only after actual checks; report/block flows, review moderation, dispute handling, transparent fees, privacy controls, account deletion/request process and audit logs.
- **Future integrations:** utility bill payment, mobile financial services, insurance or other regulated financial products only after legal/provider review, owner approval and secure official integrations. No wallet, lending, investment or financial advice claims in the initial release.

## 10. Other features
- Offers and discounts.
- Blog/tips content managed by owner.
- Referral programme only after fraud controls and reward rules are implemented.
- Shareable listing/product links and social login where configured.

## 11. Android screens
- Splash/brand screen using Elyramart identity.
- Home: global search, owner-managed promotional banners, categories, flash sale/featured products, service shortcuts and rental shortcuts.
- All categories.
- Search results with filters/sort and empty/error/loading states.
- Product details, wishlist, cart, checkout, order history/details/tracking.
- Rental marketplace, rental detail and create/edit listing.
- Service directory, provider profile, booking form and booking tracking.
- Chat, notifications, profile, addresses, settings, help/FAQ and support tickets.
- Sign-in, registration and account recovery.
- Private owner admin entry must not be visible to ordinary users; backend must independently enforce owner authorization.

## 12. Web admin panel
- Dashboard: live counts for users, products, orders and bookings; sales and order-status charts; recent orders and bookings.
- Do not hardcode illustrative numbers (for example 12,568 users); show actual database counts or an honest empty state.
- Sections: Dashboard, Users, Sellers, Products, Orders, Rentals, Bookings, Technicians, Categories, Reviews, Support Tickets, Promotions, Settings, Audit Logs, Logout.
- Owner can approve/reject seller and technician applications, moderate products/rentals, manage orders/bookings, configure categories and promotions, and review support cases.
- Admin panel must require owner authentication and server-side authorization.

## 13. Technology and integrations
- Android app: Flutter.
- Web admin: React/Next.js (after Android core stabilizes).
- Backend: existing project architecture should be audited before choosing/adding services; Firebase Auth/Firestore/Storage/Cloud Messaging may be used where appropriate. Avoid introducing a second backend stack without a migration plan.
- Maps: prefer an affordable map provider and show proper attribution. Google Maps API is optional and must not be assumed free; do not enable billing without owner approval.
- Database: Firestore or the project's established database; define indexes, validation, access rules and backup/export strategy.
- Payments: approved Bangladesh gateway integrations only after credentials and owner approval.

## 14. Quality, security and release gates
- Audit current code and dependencies before feature work; preserve existing working rental/search/owner-security code.
- Add automated tests for auth/roles, product search, rental search/ownership, booking lifecycle, order lifecycle and security rules.
- Verify loading, empty, offline, permission-denied and network-error states.
- No fake product inventory, fake reviews, fabricated dashboard statistics or simulated payment success in production mode.
- Test on a real Android device, including sign-in, search, GPS permission, listing creation, order/booking flows and owner-only access.
- Firebase/backend setup, secrets, API keys, payment merchant credentials and map billing must be configured by the owner or explicitly authorized; never commit secrets.
- No paid billing, paid API or subscription is to be enabled without explicit owner approval.
- Play Store publication is a later step after testing, privacy policy/data-safety disclosures, signing and release checks.

## Delivery phases
1. Audit current repository and build; list existing vs missing features and fix compile/runtime issues.
2. Stabilize authentication, backend configuration and owner-only security.
3. Complete marketplace, rental search/listing management and service/booking workflows.
4. Add travel and stay module: official toll payments, launch/ferry ticketing, hotel bookings and safer house-rental workflows, gated by verified provider integrations.
4. Add notifications, chat, support and owner admin functions.
5. Add the everyday-life modules in priority order: verified essential directories, jobs/education, family/home services, community help and optional planning tools.
6. Add approved payment integrations only after credentials and explicit approval.
7. Device testing, security review, performance/accessibility checks and release APK.
8. Build and deploy web admin/public website; prepare Play Store release.

## Current known project constraints
- Firebase Android package ID: `com.elyramartbd.elyramart`.
- Firebase project configuration and `google-services.json` are still required before online data/auth can be verified end-to-end.
- The previously generated APK was a demo build; do not describe online orders, payments, synchronized data, live GPS or secure admin as operational until verified.


## 15. One-app mobility and travel booking (required before claiming all-in-one)
The customer journey must remain inside Elyramart from discovery through confirmed booking, payment (where approved), ticket/booking storage, cancellation/refund request and support. Do not send customers to another app or website as the intended final experience.

### Transport modes
- **Intercity bus:** route/from-to, travel date, operator, boarding/drop points, live departure inventory, seat map with genuinely available/held/sold seats, passenger details, fare/fees, booking hold expiry, payment, provider PNR/e-ticket, cancellation/refund rules and booking history.
- **Train:** route, station, date, class, quota/category where legally supported, live train and seat/berth availability, passenger identity details required by the railway, official fare, payment, railway/provider ticket reference, downloadable ticket, cancellation/refund handling and booking history. Never imitate Bangladesh Railway inventory or issue a ticket without official authorization.
- **Launch/ferry/steamer:** route, vessel, departure, cabin/seat class, passenger manifest, live availability, fare, ticket reference and cancellation/refund handling through an authorized operator/aggregator.
- **Toll:** supported road/plaza and vehicle registration, authorized wallet/payment provider, clear fee, provider transaction reference and receipt. No claim of paid until provider confirms.
- **Hotels:** destination, check-in/out, guests/rooms, live property/room/rate inventory, taxes/fees, cancellation terms, provider confirmation and booking history.
- **House/flat/office rentals:** search, listing details, owner verification, viewing request, safe contact, application/booking workflow and dispute reporting; no deposit escrow until a compliant payment/escrow workflow is approved.

### Shared booking centre
- One in-app search and trip planner across bus, train, launch/ferry, hotel and rentals; allow multi-leg itinerary and saved passengers only with consent.
- Unified My Trips / My Bookings with provider, reference/PNR, status, ticket/receipt, support, cancellation/refund request and notification history.
- Display live availability timestamp, total price breakdown, provider identity, terms and booking hold expiry before payment.
- Use server-side provider adapters and idempotent booking/payment operations; never store raw card data or expose provider secrets in the app.
- Admin operations: provider/route configuration, booking lookup, exception queue, refund request tracking, audit log and customer support. Admin must not be able to fabricate provider confirmation.
- Search-only or request-only states must be labelled honestly. Never show fake seat maps, seat holds, live schedules, fares, ticket numbers, booking success or payment success.

### Integration/release gates
- Bus, train, launch, toll and hotel services require written provider/aggregator authorization, documented production API, sandbox certification, credentials, settlement/refund terms, customer support escalation and security/privacy review.
- Train integration specifically requires an authorized railway ticketing channel; public timetable information alone is not permission to sell or reserve seats.
- Until each provider is certified, keep the feature marked **not yet available for in-app booking** and do not redirect users as if Elyramart completed their booking.
- No paid API, gateway, subscription or billing activation without explicit owner approval.
