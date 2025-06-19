<template>
    <div class="topbar-container h-16 bg-white border-b border-gray-100 flex items-center justify-between px-8">
      <div class="flex items-center">
        <!-- Logo -->
        <a href="/" class="mr-8">
          <div class="h-10 w-10 bg-gray-900 rounded-xl flex items-center justify-center hover:bg-gray-800 transition-colors cursor-pointer">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
            </svg>
          </div>
        </a>
        
        <!-- Nav Items -->
        <div class="flex items-center space-x-6">
          <a 
            v-for="item in navItems" 
            :key="item.name"
            :href="item.path"
            :class="[
              'text-sm font-medium transition-colors duration-200',
              item.active 
                ? 'text-gray-900' 
                : 'text-gray-600 hover:text-gray-900'
            ]"
            @click.prevent="setActiveNavItem(item.path)"
          >
            {{ item.name }}
          </a>
        </div>
      </div>
  
      <div class="flex items-center">
        <div class="user-profile flex items-center relative">
          <button 
            @click="toggleDropdown" 
            class="h-9 w-9 bg-gray-900 rounded-lg flex items-center justify-center hover:bg-gray-800 transition-colors cursor-pointer"
          >
            <span class="font-medium text-sm text-white">JD</span>
          </button>
          
          <div 
            v-if="dropdownOpen" 
            class="absolute right-0 top-12 w-48 bg-white rounded-xl shadow-lg py-2 z-50 border border-gray-100"
          >
            <div class="px-4 py-2 border-b border-gray-100">
              <p class="text-sm font-medium text-gray-900">John Doe</p>
              <p class="text-xs text-gray-500">john@example.com</p>
            </div>
            
            <form action="/users/sign_out" method="post" class="block">
              <input type="hidden" name="_method" value="delete" />
              <input type="hidden" name="authenticity_token" :value="csrfToken" />
              <button type="submit" class="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 transition-colors">
                Sign out
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted, onUnmounted } from 'vue';
  
  const navItems = ref([]);
  
  const dropdownOpen = ref(false);
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || '';
  
  const toggleDropdown = () => {
    dropdownOpen.value = !dropdownOpen.value;
  };
  
  const closeDropdown = (event) => {
    if (!event.target.closest('.user-profile')) {
      dropdownOpen.value = false;
    }
  };
  
  const setActiveNavItem = (routePath) => {
    navItems.value.forEach(item => {
      item.active = item.path === routePath;
    });
  };
  
  onMounted(() => {
    const currentPath = window.location.pathname;
    setActiveNavItem(currentPath);
    
    document.addEventListener('click', closeDropdown);
  });
  
  onUnmounted(() => {
    document.removeEventListener('click', closeDropdown);
  });
  </script>