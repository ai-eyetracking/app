<template>
    <div class="topbar-container h-16 bg-white border-b border-gray-200 flex items-center justify-between px-6 shadow-sm">
      <div class="flex items-center">
        <div class="h-9 w-9 rounded-full bg-blue-500 flex items-center justify-center text-white mr-2">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
              d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
          </svg>
        </div>
        <h1 class="text-xl font-bold text-blue-500 mr-8">VisionTrack</h1>
        
        <div class="flex items-center space-x-1">
          <a 
            v-for="item in navItems" 
            :key="item.name"
            :href="item.path"
            :class="[
              'px-4 py-2 rounded-md transition-colors duration-200',
              item.active 
                ? 'bg-blue-50 text-blue-600 font-medium border-b-2 border-blue-500' 
                : 'text-gray-600 hover:text-gray-800 hover:bg-gray-50'
            ]"
            @click.prevent="setActiveNavItem(item.path)"
          >
            {{ item.name }}
          </a>
        </div>
      </div>
  
      <div class="flex items-center space-x-4">
        <div class="relative hidden md:block">
          <div class="absolute left-3 top-2 text-gray-400">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </div>
        </div>
  
        <div class="user-profile flex items-center">
          <button class="h-12 w-12 bg-blue-100 text-blue-600 rounded-full flex items-center justify-center border-2 border-white shadow-sm hover:shadow">
            <span class="font-medium text-sm">JD</span>
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