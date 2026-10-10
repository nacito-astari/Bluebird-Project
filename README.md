# Blue Bird: Transportation Database Design

A Data and Information Management project that models bookings, trips, payments, drivers, and fleet assignments for a transportation service. The project combines database design, SQL scripts, and Figma interface mockups in an academic case study based on Blue Bird.

- **Tools:** Microsoft SQL Server, SQL Server Management Studio (SSMS) 21, Draw.io, and Figma
- **Project scope:** Database analysis, conceptual and logical modelling, physical design, and interface design

## Project Overview

The project examines how customer bookings connect to drivers, vehicles, trips, and payments. It also models the supporting data needed to organise fleet availability, operational pools, and driver assignments over time.

Our group developed three ERD views, documented entities and relationships, and prepared SQL table definitions and sample data. We also designed customer and administrator screens to show how users could interact with the proposed system.

This is a student project. The database and interface designs are academic proposals, and the sample records are dummy data used for development and testing.

## Business Goals

- Connect booking, trip, and payment records so transactions can be traced across the service process.
- Organise customer, driver, vehicle, and pool information in a relational database.
- Record driver–vehicle assignments over time.
- Provide a foundation for reviewing trip history, payments, and fleet usage.

## Main Service Workflow

1. A customer places a booking with a pickup location, destination, and booking time.
2. A driver and vehicle are allocated to fulfil the booking.
3. The trip record captures the driver, vehicle, distance travelled, and start and end times.
4. A payment record stores the amount, payment method, and transaction status.

## Database Design

| Design stage | Purpose |
| --- | --- |
| **Conceptual ERD** | Identifies the main business entities and their relationships. |
| **Logical ERD** | Develops the entities into a relational model with attributes, identifiers, and relationship structures. |
| **Physical ERD** | Documents the tables, columns, data types, and keys for the SQL Server implementation. |

### Main Entities

| Entity | What it stores |
| --- | --- |
| `Pelanggan` | Customer identity and contact information. |
| `Pemesanan` | Booking time, pickup location, destination, status, and customer reference. |
| `Perjalanan` | Trip distance, start and end times, and references to the booking, driver, and vehicle. |
| `Pembayaran` | Payment amount, method, status, and trip reference. |
| `Pengemudi` | Driver identity, work status, rating, and an optional mentor reference. |
| `Armada` | Vehicle registration, availability status, production year, and pool reference. |
| `Pool` | Operational pool name, address, and capacity. |
| `Penugasan` | Driver–vehicle assignments, assignment dates, and status. |

The model also includes `BlueBirdArmada`, `SilverBirdArmada`, and `BigBirdArmada` to represent different fleet categories and their service-specific attributes.

### Design Highlights

- Uses primary and foreign keys to identify records and connect related tables.
- Uses `Penugasan` to represent driver–vehicle assignments at different times.
- Includes a self-referencing mentor relationship in `Pengemudi`.
- Models fleet categories through a superclass/subclass structure.
- Includes SQL examples using `CREATE TABLE`, `ALTER TABLE`, `INSERT`, and `SELECT`, with constraints for selected identifiers and status values.

### Physical ERD Preview

<img width="1781" height="1038" alt="Physical ERD" src="https://github.com/user-attachments/assets/374f9d9c-a9d0-487d-a054-f32e856279e1" />


The conceptual and logical ERDs are available as separate files in this repository, or use Draw.io link below provides access to the diagram source.

## User Interface Design

The Figma mockups illustrate the proposed customer and administrator interfaces:

- **Customer:** Sign-up, login, booking through a map interface, and driver information.
- **Administrator:** Login and a reporting dashboard.

The screens illustrate the proposed application experience. Figures shown in the dashboard are mockup values.
<img width="753" height="568" alt="Screenshot 2026-10-11 002457" src="https://github.com/user-attachments/assets/463b3533-dcb5-4472-a762-53dec0baeb56" />
<img width="743" height="570" alt="Screenshot 2026-10-11 002543" src="https://github.com/user-attachments/assets/e101cbc9-6109-4326-b8ab-635b6fa0c540" />

## Project Links

- [Figma interface designs](https://www.figma.com/design/Gfc5PBrw4GcL1HIjhndSMo/mybluebird-DIM?node-id=9-367)
- [Draw.io diagrams](https://app.diagrams.net/#G1gjJ3BFMkoCNq3vsFkeqkoC_FgjVZkF4L#%7B%22pageId%22%3A%22wrbaK2hLCKJaVbyBe0tK%22%7D)

The project report and presentation are provided as separate files in this repository.

## Contributors

- Nacito Florisen Astari
- Rexi Alfrids Baptista Kawuwung
- Muhamad Adittra Fahris
- Jason Danielo Marbun
- Rafhael Noah Hajoran Pakpahan

## My Contributions

- Contributed to SQL table definitions and database constraints.
- Investigated SQL syntax, foreign key, and constraint errors during development.
- Helped prepare and check dummy data for the database tables.
- Worked with team members to integrate their SQL work and resolve database issues.
