<template>
  <div class="sidebar-container h-full w-64 bg-white border-r border-gray-100 flex flex-col">
    <div class="px-5 py-4 flex justify-between items-center">
      <h2 class="text-sm font-medium text-gray-900">Projects</h2>
      <button @click="toggleModal" class="h-6 w-6 rounded-full bg-gray-100 flex items-center justify-center text-gray-700 hover:bg-gray-200 cursor-pointer">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 4v16m8-8H4" />
        </svg>
      </button>
    </div>
    
    <div class="flex-grow overflow-y-auto px-2">
      <a
        v-for="project in projects"
        :key="project.id"
        :href="getProjectUrl(project.id)"
        :class="[
          'py-2.5 px-3 my-1 rounded-md cursor-pointer flex items-start',
          isProjectActive(project.id) ? 'bg-blue-50' : 'hover:bg-gray-50'
        ]"
      >
        <div class="w-full">
          <div :class="['font-medium text-sm', isProjectActive(project.id) ? 'text-blue-600' : 'text-gray-900']">
            {{ project.title }}
          </div>
          <div class="text-xs text-gray-500 mt-0.5">
            22 images
          </div>
        </div>
      </a>
    </div>
  </div>
  <NewProjectModal :isOpen="toggleNewProjectModal" @close="toggleModal" />
</template>
 
<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import NewProjectModal from '../projects/NewProjectModal.vue';

const toggleNewProjectModal = ref(false);
const currentProjectId = ref<number | null>(null);

interface Project {
  id: number;
  title: string;
  description: string;
}

const props = defineProps<{
  projects: Project[];
}>();

onMounted(() => {
  getCurrentProjectIdFromUrl();
  
  window.addEventListener('popstate', getCurrentProjectIdFromUrl);
});

const onUnmounted = () => {
  window.removeEventListener('popstate', getCurrentProjectIdFromUrl);
};

const getCurrentProjectIdFromUrl = () => {
  const path = window.location.pathname;
  const match = path.match(/\/projects\/(\d+)/);
  
  if (match && match[1]) {
    currentProjectId.value = parseInt(match[1], 10);
  } else {
    currentProjectId.value = null;
  }
};

const isProjectActive = (id: number): boolean => {
  return currentProjectId.value === id;
};

const getProjectUrl = (id: number): string => {
  return `/projects/${id}`;
};

const toggleModal = () => {
  toggleNewProjectModal.value = !toggleNewProjectModal.value;
};
</script>