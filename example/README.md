# Smart Form Builder Example

A minimal Flutter app demonstrating the `smart_form_builder` package.

## Features Demonstrated

- Basic form rendering from JSON schema
- Text, email, and dropdown field types
- Form validation
- Submit handling with data output
- Field change callbacks

## Running the Example

1. Navigate to the example directory:
   ```bash
   cd example
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## What You'll See

- A simple form with three fields: Full Name (text), Email Address (email), and Country (dropdown)
- All fields are required and will show validation errors if left empty
- When you submit the form, the data will be printed to the console and shown in a snackbar
- Field changes are logged to the console

## Schema Structure

The example uses a simple JSON schema with:
- Field types: `text`, `email`, `dropdown`
- Validation: `required` validator
- Options: Dropdown with country choices
- Labels and placeholders for user guidance

This demonstrates the basic usage pattern for the `smart_form_builder` package. 