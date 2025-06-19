<template>
  <div class="heatmap-generator max-w-6xl mx-auto">
    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
      <h2 class="text-2xl font-bold text-gray-900 mb-6">Analysis Results</h2>
      <p class="text-gray-600 mb-8">Your heatmap and AI insights</p>
      
      <div class="grid grid-cols-2 gap-8">
        <!-- Heatmap Visualization -->
        <div class="space-y-4">
          <h3 class="text-lg font-semibold text-gray-900">Heatmap Visualization</h3>
          <div class="bg-gray-100 rounded-lg h-96 flex items-center justify-center relative">
            <div v-if="!heatmapData" class="text-center">
              <svg class="mx-auto h-12 w-12 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
              </svg>
              <p class="text-gray-500 mb-4">No heatmap generated yet</p>
              <button 
                @click="generateHeatmap"
                :disabled="isGenerating"
                class="inline-flex items-center px-4 py-2 rounded-lg text-sm font-medium text-white bg-gray-900 hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-900 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
              >
                <span v-if="isGenerating" class="flex items-center">
                  <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Generating...
                </span>
                <span v-else>Generate Heatmap</span>
              </button>
            </div>
            <div v-else>
              <!-- Heatmap display will go here -->
              <p class="text-gray-500">Heatmap visualization</p>
            </div>
          </div>
        </div>
        
        <!-- AI Suggestions -->
        <div class="space-y-4">
          <h3 class="text-lg font-semibold text-gray-900">AI Insights & Suggestions</h3>
          <div class="bg-gray-100 rounded-lg h-96 overflow-y-auto p-6">
            <div v-if="!suggestions || suggestions.length === 0" class="text-center">
              <svg class="mx-auto h-12 w-12 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                      d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
              </svg>
              <p class="text-gray-500 mb-4">No suggestions generated yet</p>
              <button 
                @click="generateSuggestions"
                :disabled="isGeneratingSuggestions || !heatmapData"
                class="inline-flex items-center px-4 py-2 rounded-lg text-sm font-medium text-white bg-gray-900 hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-900 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
              >
                <span v-if="isGeneratingSuggestions" class="flex items-center">
                  <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Generating...
                </span>
                <span v-else>Get AI Suggestions</span>
              </button>
            </div>
            <div v-else class="space-y-4">
              <div v-for="(suggestion, index) in suggestions" :key="index" 
                   class="bg-white rounded-lg p-4 border border-gray-200">
                <div class="flex items-start space-x-3">
                  <div class="flex-shrink-0">
                    <div class="h-8 w-8 rounded-full flex items-center justify-center"
                         :class="getSuggestionPriorityClass(suggestion.priority)">
                      <span class="text-xs font-bold text-white">{{ index + 1 }}</span>
                    </div>
                  </div>
                  <div class="flex-1">
                    <p class="text-sm font-medium text-gray-900">{{ suggestion.title }}</p>
                    <p class="text-sm text-gray-600 mt-1">{{ suggestion.content }}</p>
                    <div class="mt-2 flex items-center space-x-4 text-xs text-gray-500">
                      <span class="capitalize">{{ suggestion.type }}</span>
                      <span>•</span>
                      <span class="capitalize">{{ suggestion.priority }} priority</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Action Buttons -->
      <div class="mt-8 flex justify-between items-center">
        <div class="flex space-x-4">
          <button 
            @click="downloadReport"
            :disabled="!heatmapData"
            class="inline-flex items-center px-4 py-2 rounded-lg text-sm font-medium text-gray-700 bg-white border border-gray-300 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
          >
            <svg class="mr-2 h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" 
                    d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
            Download Report
          </button>
        </div>
        
        <div class="flex space-x-4">
          <button 
            @click="$emit('back')"
            class="px-6 py-2.5 rounded-lg text-sm font-medium text-gray-700 bg-white border border-gray-300 hover:bg-gray-50"
          >
            Back to Analysis
          </button>
          <button 
            @click="saveAndFinish"
            :disabled="!heatmapData"
            class="px-6 py-2.5 rounded-lg text-sm font-medium text-white bg-gray-900 hover:bg-gray-800 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
          >
            Save & Finish
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  analysisId: {
    type: String,
    required: true
  },
  versionId: {
    type: String,
    required: false
  }
})

const emit = defineEmits(['back', 'complete'])

// Reactive state
const heatmapData = ref(null)
const suggestions = ref([])
const isGenerating = ref(false)
const isGeneratingSuggestions = ref(false)

// Generate heatmap
const generateHeatmap = async () => {
  isGenerating.value = true
  
  try {
    // Call your heatmap generation API
    const response = await fetch(`/analyses/${props.analysisId}/generate_heatmap`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ version_id: props.versionId })
    })
    
    if (response.ok) {
      const data = await response.json()
      heatmapData.value = data.heatmap
    } else {
      throw new Error('Failed to generate heatmap')
    }
  } catch (error) {
    console.error('Heatmap generation error:', error)
    alert('Failed to generate heatmap. Please try again.')
  } finally {
    isGenerating.value = false
  }
}

// Generate AI suggestions
const generateSuggestions = async () => {
  isGeneratingSuggestions.value = true
  
  try {
    // Call your AI suggestions API
    const response = await fetch(`/analyses/${props.analysisId}/generate_suggestions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ version_id: props.versionId })
    })
    
    if (response.ok) {
      const data = await response.json()
      suggestions.value = data.suggestions
    } else {
      throw new Error('Failed to generate suggestions')
    }
  } catch (error) {
    console.error('Suggestions generation error:', error)
    alert('Failed to generate suggestions. Please try again.')
  } finally {
    isGeneratingSuggestions.value = false
  }
}

// Download report
const downloadReport = () => {
  // Implement download functionality
  window.open(`/analyses/${props.analysisId}/download_report`, '_blank')
}

// Save and finish
const saveAndFinish = () => {
  emit('complete', {
    heatmapData: heatmapData.value,
    suggestions: suggestions.value
  })
}

// Helper function for suggestion priority styling
const getSuggestionPriorityClass = (priority) => {
  const classes = {
    low: 'bg-gray-400',
    medium: 'bg-yellow-500',
    high: 'bg-orange-500',
    critical: 'bg-red-500'
  }
  return classes[priority] || 'bg-gray-400'
}
</script>

<style scoped>
/* Custom styles if needed */
</style>