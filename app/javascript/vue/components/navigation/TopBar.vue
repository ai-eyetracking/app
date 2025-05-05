<template>
    <div class="topbar-container h-14 bg-white backdrop-blur-sm bg-opacity-90 border-b border-gray-100 flex items-center justify-between px-8 shadow-sm">
      <div class="flex items-center">
        <div class="mr-5">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-gray-800" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" 
              d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
          </svg>
        </div>
        
        <div class="flex items-center space-x-8">
          <a 
            v-for="item in navItems" 
            :key="item.name"
            :href="item.path"
            :class="[
              'text-sm transition-colors duration-200',
              item.active 
                ? 'text-black font-medium' 
                : 'text-gray-500 hover:text-gray-800'
            ]"
            @click.prevent="setActiveNavItem(item.path)"
          >
            {{ item.name }}
          </a>
        </div>
      </div>
  
      <div class="flex items-center">
        <div class="user-profile flex items-center">
          <button class="h-8 w-8 bg-gray-100 rounded-full flex items-center justify-center">
            <span class="font-medium text-xs text-gray-800">JD</span>
          </button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  
  const navItems = ref([
    { name: 'Dashboard', path: '/', active: true },
    { name: 'Reports', path: '/reports', active: false },
    { name: 'Settings', path: '/settings', active: false }
  ]);
  
  const setActiveNavItem = (routePath) => {
    navItems.value.forEach(item => {
      item.active = item.path === routePath;
    });
  };
  
  onMounted(() => {
    const currentPath = window.location.pathname;
    setActiveNavItem(currentPath);
  });
  </script>