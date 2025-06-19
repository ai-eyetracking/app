<template>
  <div class="key-area-editor">
    <div class="flex gap-6">
      <!-- Image Canvas -->
      <div class="flex-1">
        <div class="bg-white rounded-lg border border-gray-200 p-4">
          <div class="mb-4 flex items-center justify-between">
            <h3 class="text-lg font-semibold text-gray-900">Define Key Areas</h3>
            <div class="flex items-center space-x-2">
              <button
                @click="clearAllAreas"
                :disabled="keyAreas.length === 0"
                class="px-3 py-1.5 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Clear All
              </button>
              <button
                @click="toggleDrawing"
                class="px-3 py-1.5 text-sm font-medium rounded-md"
                :class="isDrawing ? 'bg-red-100 text-red-700 hover:bg-red-200' : 'bg-gray-900 text-white hover:bg-gray-800'"
              >
                {{ isDrawing ? 'Cancel Drawing' : 'Add Area' }}
              </button>
            </div>
          </div>
          
          <div class="relative inline-block" ref="canvasContainer">
            <img
              :src="imageSrc"
              alt="Design"
              class="max-w-full h-auto"
              @load="onImageLoad"
              ref="imageRef"
            />
            
            <!-- Drawing overlay -->
            <div
              v-if="isDrawing"
              class="absolute inset-0 cursor-crosshair"
              @mousedown="startDrawing"
              @mousemove="updateDrawing"
              @mouseup="finishDrawing"
              @mouseleave="cancelDrawing"
            >
              <!-- Current drawing rectangle -->
              <div
                v-if="currentRect"
                class="absolute border-2 border-blue-500 bg-blue-500 bg-opacity-20"
                :style="{
                  left: currentRect.x + 'px',
                  top: currentRect.y + 'px',
                  width: currentRect.width + 'px',
                  height: currentRect.height + 'px'
                }"
              ></div>
            </div>
            
            <!-- Existing key areas -->
            <div
              v-for="(area, index) in keyAreas"
              :key="area.id"
              class="absolute border-2 cursor-move group"
              :class="getAreaColorClass(area.label)"
              :style="{
                left: area.x + 'px',
                top: area.y + 'px',
                width: area.width + 'px',
                height: area.height + 'px'
              }"
              @mousedown="startDragging(area, $event)"
            >
              <!-- Area label -->
              <div class="absolute -top-6 left-0 px-2 py-1 text-xs font-medium text-white rounded"
                   :class="getAreaLabelClass(area.label)">
                {{ area.label }}
              </div>
              
              <!-- Delete button -->
              <button
                @click.stop="deleteArea(index)"
                class="absolute -top-2 -right-2 w-6 h-6 bg-red-500 text-white rounded-full opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
              
              <!-- Resize handles -->
              <div class="absolute -bottom-1 -right-1 w-3 h-3 bg-white border-2 border-gray-400 cursor-se-resize"
                   @mousedown.stop="startResizing(area, $event)"></div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Sidebar -->
      <div class="w-80">
        <!-- Label Selection -->
        <div class="bg-white rounded-lg border border-gray-200 p-4 mb-4">
          <h4 class="text-sm font-semibold text-gray-900 mb-3">Select Label for New Area</h4>
          <div class="space-y-2">
            <label
              v-for="label in availableLabels"
              :key="label.value"
              class="flex items-center p-2 rounded-md cursor-pointer hover:bg-gray-50"
              :class="{ 'bg-gray-100': selectedLabel === label.value }"
            >
              <input
                type="radio"
                :value="label.value"
                v-model="selectedLabel"
                class="mr-3"
              />
              <div class="flex items-center flex-1">
                <div class="w-3 h-3 rounded-full mr-2" :class="label.colorClass"></div>
                <span class="text-sm font-medium text-gray-700">{{ label.name }}</span>
              </div>
            </label>
          </div>
        </div>
        
        <!-- Key Areas List -->
        <div class="bg-white rounded-lg border border-gray-200 p-4">
          <h4 class="text-sm font-semibold text-gray-900 mb-3">
            Defined Areas ({{ keyAreas.length }})
          </h4>
          <div v-if="keyAreas.length === 0" class="text-sm text-gray-500 text-center py-4">
            No areas defined yet. Click "Add Area" and draw on the image.
          </div>
          <div v-else class="space-y-2">
            <div
              v-for="(area, index) in keyAreas"
              :key="area.id"
              class="flex items-center justify-between p-2 rounded-md bg-gray-50"
            >
              <div class="flex items-center">
                <div class="w-3 h-3 rounded-full mr-2" :class="getAreaColorClass(area.label)"></div>
                <span class="text-sm font-medium text-gray-700">{{ area.label }}</span>
              </div>
              <button
                @click="deleteArea(index)"
                class="text-red-600 hover:text-red-700"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                        d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                </svg>
              </button>
            </div>
          </div>
        </div>
        
        <!-- Instructions -->
        <div class="mt-4 bg-blue-50 rounded-lg p-4">
          <h4 class="text-sm font-semibold text-blue-900 mb-2">Instructions</h4>
          <ul class="text-sm text-blue-700 space-y-1">
            <li>• Select a label from above</li>
            <li>• Click "Add Area" to start drawing</li>
            <li>• Click and drag on the image to create an area</li>
            <li>• Drag areas to reposition them</li>
            <li>• Use the corner handle to resize</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  imageSrc: {
    type: String,
    required: true
  },
  initialAreas: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['update:areas'])

// Predefined labels - hardcoded for now
const availableLabels = [
  { value: 'logo', name: 'Logo', colorClass: 'bg-purple-500' },
  { value: 'main_menu', name: 'Main Menu', colorClass: 'bg-blue-500' },
  { value: 'hero_section', name: 'Hero Section', colorClass: 'bg-green-500' },
  { value: 'product', name: 'Product', colorClass: 'bg-yellow-500' },
  { value: 'cta_button', name: 'CTA Button', colorClass: 'bg-red-500' },
  { value: 'footer', name: 'Footer', colorClass: 'bg-gray-500' },
  { value: 'sidebar', name: 'Sidebar', colorClass: 'bg-indigo-500' },
  { value: 'content_area', name: 'Content Area', colorClass: 'bg-pink-500' },
  { value: 'navigation', name: 'Navigation', colorClass: 'bg-teal-500' },
  { value: 'search_bar', name: 'Search Bar', colorClass: 'bg-orange-500' }
]

// Refs
const canvasContainer = ref(null)
const imageRef = ref(null)
const keyAreas = ref([...props.initialAreas])
const isDrawing = ref(false)
const currentRect = ref(null)
const startPoint = ref(null)
const selectedLabel = ref('logo')
const nextId = ref(1)

// Dragging state
const dragState = ref({
  isDragging: false,
  area: null,
  offsetX: 0,
  offsetY: 0
})

// Resizing state
const resizeState = ref({
  isResizing: false,
  area: null,
  startX: 0,
  startY: 0,
  startWidth: 0,
  startHeight: 0
})

// Color mapping
const getAreaColorClass = (label) => {
  const labelConfig = availableLabels.find(l => l.value === label)
  return labelConfig ? labelConfig.colorClass.replace('bg-', 'border-').replace('500', '400') + ' bg-opacity-20 ' + labelConfig.colorClass : 'border-gray-400 bg-gray-500 bg-opacity-20'
}

const getAreaLabelClass = (label) => {
  const labelConfig = availableLabels.find(l => l.value === label)
  return labelConfig ? labelConfig.colorClass : 'bg-gray-500'
}

// Image load handler
const onImageLoad = () => {
  // Image loaded, ready for drawing
}

// Drawing functions
const toggleDrawing = () => {
  isDrawing.value = !isDrawing.value
  if (!isDrawing.value) {
    currentRect.value = null
    startPoint.value = null
  }
}

const startDrawing = (event) => {
  const rect = canvasContainer.value.getBoundingClientRect()
  startPoint.value = {
    x: event.clientX - rect.left,
    y: event.clientY - rect.top
  }
  currentRect.value = {
    x: startPoint.value.x,
    y: startPoint.value.y,
    width: 0,
    height: 0
  }
}

const updateDrawing = (event) => {
  if (!startPoint.value || !currentRect.value) return
  
  const rect = canvasContainer.value.getBoundingClientRect()
  const currentX = event.clientX - rect.left
  const currentY = event.clientY - rect.top
  
  currentRect.value = {
    x: Math.min(startPoint.value.x, currentX),
    y: Math.min(startPoint.value.y, currentY),
    width: Math.abs(currentX - startPoint.value.x),
    height: Math.abs(currentY - startPoint.value.y)
  }
}

const finishDrawing = () => {
  if (currentRect.value && currentRect.value.width > 10 && currentRect.value.height > 10) {
    // Add the new area
    keyAreas.value.push({
      id: `area_${nextId.value++}`,
      label: selectedLabel.value,
      x: currentRect.value.x,
      y: currentRect.value.y,
      width: currentRect.value.width,
      height: currentRect.value.height
    })
    emit('update:areas', keyAreas.value)
  }
  
  currentRect.value = null
  startPoint.value = null
  isDrawing.value = false
}

const cancelDrawing = () => {
  currentRect.value = null
  startPoint.value = null
}

// Area management
const deleteArea = (index) => {
  keyAreas.value.splice(index, 1)
  emit('update:areas', keyAreas.value)
}

const clearAllAreas = () => {
  keyAreas.value = []
  emit('update:areas', keyAreas.value)
}

// Dragging functionality
const startDragging = (area, event) => {
  if (isDrawing.value) return
  
  const rect = canvasContainer.value.getBoundingClientRect()
  dragState.value = {
    isDragging: true,
    area: area,
    offsetX: event.clientX - rect.left - area.x,
    offsetY: event.clientY - rect.top - area.y
  }
  
  document.addEventListener('mousemove', handleDragging)
  document.addEventListener('mouseup', stopDragging)
}

const handleDragging = (event) => {
  if (!dragState.value.isDragging) return
  
  const rect = canvasContainer.value.getBoundingClientRect()
  const newX = event.clientX - rect.left - dragState.value.offsetX
  const newY = event.clientY - rect.top - dragState.value.offsetY
  
  // Keep within bounds
  dragState.value.area.x = Math.max(0, Math.min(newX, rect.width - dragState.value.area.width))
  dragState.value.area.y = Math.max(0, Math.min(newY, rect.height - dragState.value.area.height))
  
  emit('update:areas', keyAreas.value)
}

const stopDragging = () => {
  dragState.value = {
    isDragging: false,
    area: null,
    offsetX: 0,
    offsetY: 0
  }
  document.removeEventListener('mousemove', handleDragging)
  document.removeEventListener('mouseup', stopDragging)
}

// Resizing functionality
const startResizing = (area, event) => {
  event.stopPropagation()
  resizeState.value = {
    isResizing: true,
    area: area,
    startX: event.clientX,
    startY: event.clientY,
    startWidth: area.width,
    startHeight: area.height
  }
  
  document.addEventListener('mousemove', handleResizing)
  document.addEventListener('mouseup', stopResizing)
}

const handleResizing = (event) => {
  if (!resizeState.value.isResizing) return
  
  const deltaX = event.clientX - resizeState.value.startX
  const deltaY = event.clientY - resizeState.value.startY
  
  resizeState.value.area.width = Math.max(20, resizeState.value.startWidth + deltaX)
  resizeState.value.area.height = Math.max(20, resizeState.value.startHeight + deltaY)
  
  emit('update:areas', keyAreas.value)
}

const stopResizing = () => {
  resizeState.value = {
    isResizing: false,
    area: null,
    startX: 0,
    startY: 0,
    startWidth: 0,
    startHeight: 0
  }
  document.removeEventListener('mousemove', handleResizing)
  document.removeEventListener('mouseup', stopResizing)
}

// Watch for external changes
watch(() => props.initialAreas, (newAreas) => {
  keyAreas.value = [...newAreas]
}, { deep: true })
</script>

<style scoped>
/* Cursor styles */
.cursor-crosshair {
  cursor: crosshair !important;
}

.cursor-move {
  cursor: move !important;
}

.cursor-se-resize {
  cursor: se-resize !important;
}

/* Area styles with proper opacity */
.bg-purple-500.bg-opacity-20 {
  background-color: rgba(168, 85, 247, 0.2);
}

.bg-blue-500.bg-opacity-20 {
  background-color: rgba(59, 130, 246, 0.2);
}

.bg-green-500.bg-opacity-20 {
  background-color: rgba(34, 197, 94, 0.2);
}

.bg-yellow-500.bg-opacity-20 {
  background-color: rgba(234, 179, 8, 0.2);
}

.bg-red-500.bg-opacity-20 {
  background-color: rgba(239, 68, 68, 0.2);
}

.bg-gray-500.bg-opacity-20 {
  background-color: rgba(107, 114, 128, 0.2);
}

.bg-indigo-500.bg-opacity-20 {
  background-color: rgba(99, 102, 241, 0.2);
}

.bg-pink-500.bg-opacity-20 {
  background-color: rgba(236, 72, 153, 0.2);
}

.bg-teal-500.bg-opacity-20 {
  background-color: rgba(20, 184, 166, 0.2);
}

.bg-orange-500.bg-opacity-20 {
  background-color: rgba(249, 115, 22, 0.2);
}
</style>