# HNG Task 4

## Shop Quick

## Description

A simple shopping app that displays a list of products/items fetched from the Timu API and includes a checkout screen.

## Commit Convention

Conventional Commits is a specification for adding human and machine-readable meaning to commit messages. The format is:

```bash
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- feat: A new feature
- fix: A bug fix
- docs: Documentation only changes
- style: Changes that do not affect the meaning of the code
- refactor: A code change that neither fixes a bug nor adds a feature
- perf: A code change that improves performance
- test: Adding missing tests or correcting existing tests
- build: Changes that affect the build system or external dependencies
- ci: Changes to our CI configuration files and scripts
- chore: Other changes that don't modify src or test files
- revert: Reverts a previous commit
...

## Objectives

- Create a pixel-perfect shopping app based on the Timbu Shop designs.**

- All products must be fetched from the Timbu API. No Placeholder should be found in your app.
- Have at least 20 Unique Products in your product list. They should be categorized.
- Implement the feature of adding and removing products, wishlist or bookmark, checkout of order etc. based on your Timbu Shop design.
- Provide a good shopping experience from start to the completion of an order.
- Create an Orders history screen showing all the completed orders made on your Timbu shop. Add an icon on your home screen top bar that navigates to the order history screen. Come up with the design if not available.
- The Orders history item when clicked must go to a details screen of that order and show details of that order.
- The items in the order history screen and details should be cached in a database.
- Ensure proper UI state management and handle errors properly.
- Fix all noticeable issues.

## Acceptance Criteria

- **No Third-party Dependencies**: Built without importing any third-party packages, plugins, or libraries. Only native functionalities and components are used.
- **Intuitive and Adaptive UI**: User-friendly and intuitive interface, with clear labeling, easy navigation, and proper spacing.
- **Proper README File**: Contains setup instructions, app screenshots, apk download link, etc.

## Screenshots

| Products Screen                                                                 | Product Detail Screen                                                             | Checkout Screen                                                                  | Order Successful Screen                                                           |
|---------------------------------------------------------------------------------|----------------------------------------------------------------------------------|----------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| ![Products Screen](screenshots/products_screen.png)                             | ![Product Detail Screen](screenshots/product_detail_screen.png)                   | ![Checkout Screen](screenshots/checkout_screen.png)                              | ![Order Successful Screen](screenshots/order_successful_screen.png)               |

| Wishlist Screen                                                                 | Cart Screen                                                                      | History Screen                                                                   |                                                                                   |
|---------------------------------------------------------------------------------|----------------------------------------------------------------------------------|----------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| ![Wishlist Screen](screenshots/wishlist_screen.png)                             | ![Cart Screen](screenshots/cart_screen.png)                                       | ![History Screen](screenshots/history_screen.png)                                |                                                                                   |

## Setup Instructions

1. Clone the repository:

    ```sh
    git clone https://github.com/MrKhay/shop_quick_hng_task_4.git 
    cd shop_quick_hng_task_4
    ```

2. Open the project in your chosen development environment (e.g., Android Studio for Android, Xcode for iOS).

3. Build and run the app on an emulator or physical device.

## Figman Design Link

View design [here](https://www.figma.com/design/clF99fTP4N8Brmt0PtPz5C/HNG-Internship-projects?node-id=19-3&t=aafjHDWLeTo6Ua7I-0).

## APK Download

Download the APK file from [here](https://github.com/MrKhay/shop_quick_hng_task_4/releases/tag/v1.0.0).

## Appetize.io Showcase

Check out the virtualized demonstration of the app on [Appetize.io](https://appetize.io/app/b_ujuel7lkql4wnhbabtui74zld4).

## Contact

For any questions or issues, please contact [MrKhay](https://x.com/iKhayDev).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
