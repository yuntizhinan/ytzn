/**
 * 云梯指南 (nodehub168.com) - Core Javascript Utilities
 * Features: Mobile Nav Toggle, Scroll Header Effects, Smooth Interactions
 */

document.addEventListener('DOMContentLoaded', () => {
  initMobileMenu();
  initHeaderScroll();
  initSmoothScroll();
});

/**
 * Mobile Navigation Toggle and Accessibility state management
 */
function initMobileMenu() {
  const menuToggle = document.querySelector('.menu-toggle');
  const mainNav = document.querySelector('.main-nav');
  
  if (!menuToggle || !mainNav) return;

  menuToggle.addEventListener('click', (e) => {
    e.stopPropagation();
    const isActive = mainNav.classList.toggle('active');
    menuToggle.classList.toggle('active');
    
    // Toggle aria-expanded for accessibility
    menuToggle.setAttribute('aria-expanded', isActive ? 'true' : 'false');
    
    // Disable body scroll when menu is active on mobile
    if (isActive) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
  });

  // Close mobile nav when clicking outside the menu
  document.addEventListener('click', (e) => {
    if (mainNav.classList.contains('active') && !mainNav.contains(e.target) && !menuToggle.contains(e.target)) {
      mainNav.classList.remove('active');
      menuToggle.classList.remove('active');
      menuToggle.setAttribute('aria-expanded', 'false');
      document.body.style.overflow = '';
    }
  });

  // Close mobile nav when clicking a nav link
  const navLinks = mainNav.querySelectorAll('.nav-link');
  navLinks.forEach(link => {
    link.addEventListener('click', () => {
      if (mainNav.classList.contains('active')) {
        mainNav.classList.remove('active');
        menuToggle.classList.remove('active');
        menuToggle.setAttribute('aria-expanded', 'false');
        document.body.style.overflow = '';
      }
    });
  });
}

/**
 * Dynamically updates header appearance on scroll
 */
function initHeaderScroll() {
  const header = document.querySelector('.site-header');
  if (!header) return;

  const handleScroll = () => {
    if (window.scrollY > 50) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
  };

  // Initial call to set correct state if page is loaded scrolled
  handleScroll();
  
  window.addEventListener('scroll', handleScroll, { passive: true });
}

/**
 * Handle active navigation highlighting and scroll-padding adjustments
 */
function initSmoothScroll() {
  const links = document.querySelectorAll('.nav-link');
  const sections = document.querySelectorAll('section[id]');
  
  if (links.length === 0) return;

  // Active link styling on scroll
  const highlightNav = () => {
    let scrollY = window.pageYOffset;
    
    sections.forEach(current => {
      const sectionHeight = current.offsetHeight;
      const sectionTop = current.offsetTop - 100; // Offset for header height
      const sectionId = current.getAttribute('id');
      
      if (scrollY > sectionTop && scrollY <= sectionTop + sectionHeight) {
        document.querySelector(`.main-nav a[href*="${sectionId}"]`)?.classList.add('active');
      } else {
        document.querySelector(`.main-nav a[href*="${sectionId}"]`)?.classList.remove('active');
      }
    });
  };

  window.addEventListener('scroll', highlightNav, { passive: true });
}
