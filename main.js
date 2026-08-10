document.addEventListener('DOMContentLoaded', () => {
  // 1. Sticky Header Scroll Effect
  const header = document.querySelector('.header');
  const handleScroll = () => {
    if (window.scrollY > 20) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
  };
  window.addEventListener('scroll', handleScroll);
  handleScroll(); // Initial check in case of page reload with scroll

  // 2. Mobile Menu & Dropdown Toggles
  const burger = document.querySelector('.burger');
  const navMenu = document.querySelector('.nav-menu');
  const dropdownLinks = document.querySelectorAll('.nav-link.has-dropdown');

  // Open/Close mobile menu
  if (burger && navMenu) {
    burger.addEventListener('click', (e) => {
      e.stopPropagation();
      navMenu.classList.toggle('open');
      burger.classList.toggle('active');
    });

    // Close mobile menu when clicking outside
    document.addEventListener('click', (e) => {
      if (!navMenu.contains(e.target) && !burger.contains(e.target)) {
        navMenu.classList.remove('open');
        burger.classList.remove('active');
      }
    });
  }

  // Handle dropdown menus on mobile (click instead of hover)
  dropdownLinks.forEach(link => {
    link.addEventListener('click', (e) => {
      if (window.innerWidth <= 768) {
        e.preventDefault();
        e.stopPropagation();
        
        const dropdownMenu = link.nextElementSibling;
        const isOpen = dropdownMenu.classList.contains('open');
        
        // Close other dropdowns first
        document.querySelectorAll('.dropdown-menu').forEach(menu => {
          menu.classList.remove('open');
        });
        document.querySelectorAll('.nav-link.has-dropdown').forEach(item => {
          item.classList.remove('active-toggle');
        });

        // Toggle current dropdown
        if (!isOpen) {
          dropdownMenu.classList.add('open');
          link.classList.add('active-toggle');
        }
      }
    });
  });

  // 3. Tutorial Tabs Navigation
  const tabButtons = document.querySelectorAll('.tab-btn');
  const tabContents = document.querySelectorAll('.tab-content');

  tabButtons.forEach(button => {
    button.addEventListener('click', () => {
      const targetId = button.getAttribute('data-tab');
      
      // Remove active states
      tabButtons.forEach(btn => btn.classList.remove('active'));
      tabContents.forEach(content => content.classList.remove('active'));
      
      // Set active states
      button.classList.add('active');
      const targetContent = document.getElementById(targetId);
      if (targetContent) {
        targetContent.classList.add('active');
      }
    });
  });

  // 4. FAQ Accordion Toggle
  const faqHeaders = document.querySelectorAll('.faq-header');

  faqHeaders.forEach(header => {
    header.addEventListener('click', () => {
      const faqItem = header.parentElement;
      const faqBody = faqItem.querySelector('.faq-body');
      const isActive = faqItem.classList.contains('active');

      // Close all other FAQ items first for accordion effect
      document.querySelectorAll('.faq-item').forEach(item => {
        item.classList.remove('active');
        item.querySelector('.faq-body').style.maxHeight = null;
      });

      // Toggle current item
      if (!isActive) {
        faqItem.classList.add('active');
        faqBody.style.maxHeight = faqBody.scrollHeight + 'px';
      }
    });
  });
});
