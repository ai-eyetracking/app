# Eye-Tracking Analysis Application - Development Instructions

## Project Overview
This is a Ruby on Rails application with Vue.js frontend components for eye-tracking heatmap analysis and design optimization. The app helps users analyze designs through heatmaps and receive AI-powered suggestions for improvements.

## Tech Stack
- **Backend**: Ruby on Rails
- **Frontend**: Vue.js components mounted through HTML.ERB templates
- **Component Management**: components.ts for Vue component registration
- **File Storage**: Direct filesystem storage for images
- **External APIs**: Heatmap generation and AI suggestions via external services

## Core Application Structure

### 1. Models Required

#### Project Model
```ruby
# app/models/project.rb
class Project < ApplicationRecord
  has_many :analyses, dependent: :destroy
  
  validates :name, presence: true
  validates :project_type, presence: true
  
  enum project_type: {
    redesign: 0,
    product_packaging: 1,
    social_media_ad: 2,
    website: 3,
    landing_page: 4
  }
end
```

#### Analysis Model (with versioning support)
```ruby
# app/models/analysis.rb
class Analysis < ApplicationRecord
  belongs_to :project
  has_many :versions, class_name: 'AnalysisVersion', dependent: :destroy
  has_many :key_areas, dependent: :destroy
  
  validates :name, presence: true
  validates :domain_type, presence: true
  
  # Domain types like: homepage, product_card, footer, header, etc.
  enum domain_type: {
    homepage: 0,
    product_card: 1,
    footer: 2,
    header: 3,
    navigation: 4,
    checkout: 5
  }
  
  def current_version
    versions.order(version_number: :desc).first
  end
  
  def latest_heatmap_data
    current_version&.heatmap_data
  end
end
```

#### AnalysisVersion Model (for version control)
```ruby
# app/models/analysis_version.rb
class AnalysisVersion < ApplicationRecord
  belongs_to :analysis
  has_many :suggestions, dependent: :destroy
  
  validates :version_number, presence: true, uniqueness: { scope: :analysis_id }
  validates :image_path, presence: true
  
  before_create :set_version_number
  
  # JSON fields for storing external API responses
  # heatmap_data: stores heatmap coordinates and intensity data
  # custom_scoring: stores scoring results from external API
  
  scope :ordered, -> { order(:version_number) }
  
  private
  
  def set_version_number
    self.version_number = (analysis.versions.maximum(:version_number) || 0) + 1
  end
end
```

#### KeyArea Model (for defining important areas on designs)
```ruby
# app/models/key_area.rb
class KeyArea < ApplicationRecord
  belongs_to :analysis
  
  validates :name, presence: true
  validates :x_coordinate, :y_coordinate, :width, :height, presence: true
  
  enum area_type: {
    cta_button: 0,
    logo: 1,
    navigation: 2,
    content_area: 3,
    form: 4,
    image: 5
  }
  
  # Coordinates stored as percentages for responsive design
end
```

#### Suggestion Model
```ruby
# app/models/suggestion.rb
class Suggestion < ApplicationRecord
  belongs_to :analysis_version
  
  validates :content, presence: true
  validates :suggestion_type, presence: true
  validates :priority, presence: true
  
  enum suggestion_type: {
    layout_improvement: 0,
    color_adjustment: 1,
    positioning: 2,
    content_optimization: 3,
    user_flow: 4
  }
  
  enum priority: {
    low: 0,
    medium: 1,
    high: 2,
    critical: 3
  }
  
  scope :by_priority, -> { order(priority: :desc) }
end
```



### 2. Controllers Structure

#### ProjectsController
- Standard CRUD operations
- Project dashboard with analyses overview
- Project type-specific custom scoring logic

#### AnalysesController
- CRUD for analyses within projects
- Heatmap request handling (external API integration)
- Key area management interface

#### AnalysisVersionsController
- Version creation and management
- Image upload handling
- Version comparison views

#### SuggestionsController
- Request suggestions from external AI API
- Display and manage suggestions
- Track suggestion implementation status

### 3. Vue.js Components Structure

#### Core Components (components.ts registration)
```typescript
// app/javascript/components.ts
import HeatmapViewer from './components/HeatmapViewer.vue'
import KeyAreaEditor from './components/KeyAreaEditor.vue'
import VersionComparison from './components/VersionComparison.vue'
import SuggestionPanel from './components/SuggestionPanel.vue'
import CustomScoringDisplay from './components/CustomScoringDisplay.vue'

export const components = {
  HeatmapViewer,
  KeyAreaEditor,
  VersionComparison,
  SuggestionPanel,
  CustomScoringDisplay
}
```

#### Component Responsibilities

**HeatmapViewer.vue**
- Display uploaded design image
- Overlay heatmap data from external API
- Interactive zoom and pan functionality
- Key area highlighting

**KeyAreaEditor.vue**
- Draw and edit key areas on design
- Drag-and-drop area positioning
- Area type selection and naming
- Save coordinates as percentages

**VersionComparison.vue**
- Side-by-side version comparison
- Heatmap differences visualization
- Scoring comparison charts
- A/B testing results display

**SuggestionPanel.vue**
- Display AI suggestions by priority
- Mark suggestions as implemented
- Request new suggestions for versions
- Track suggestion history

**CustomScoringDisplay.vue**
- Show custom scoring results
- "All good!" display for high scores
- Score breakdown by analysis type
- Progress tracking over versions

### 4. Database Migrations

```ruby
# Migration examples
class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.integer :project_type, null: false
      t.text :description
      t.timestamps
    end
    
    add_index :projects, :project_type
  end
end

class CreateAnalyses < ActiveRecord::Migration[7.0]
  def change
    create_table :analyses do |t|
      t.references :project, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :domain_type, null: false
      t.timestamps
    end
  end
end

class CreateAnalysisVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :analysis_versions do |t|
      t.references :analysis, null: false, foreign_key: true
      t.integer :version_number, null: false
      t.string :image_path, null: false
      t.json :heatmap_data
      t.json :custom_scoring
      t.text :notes
      t.timestamps
    end
    
    add_index :analysis_versions, [:analysis_id, :version_number], unique: true
  end
end
```

### 5. External API Integration

#### Services Structure
```ruby
# app/services/heatmap_service.rb
class HeatmapService
  def self.generate_heatmap(image_path, analysis_type)
    # Call external heatmap API
    # Return heatmap data for storage
  end
end

# app/services/suggestion_service.rb
class SuggestionService
  def self.generate_suggestions(analysis_version, key_areas)
    # Call external AI API
    # Include custom scoring context
    # Return formatted suggestions
  end
end

# app/services/custom_scoring_service.rb
class CustomScoringService
  def self.calculate_score(analysis_version, project_type)
    # Implement custom scoring logic per project type
    # Use key areas and heatmap data
    # Return score and recommendations
  end
end
```

### 6. File Storage Structure
```
storage/
├── projects/
│   ├── {project_id}/
│   │   ├── analyses/
│   │   │   ├── {analysis_id}/
│   │   │   │   ├── versions/
│   │   │   │   │   ├── v1_original.jpg
│   │   │   │   │   ├── v2_updated.jpg
│   │   │   │   │   └── ...
│   │   │   │   └── heatmaps/
│   │   │   │       ├── v1_heatmap.json
│   │   │   │       └── v2_heatmap.json
```

### 7. Routes Structure
```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :projects do
    resources :analyses do
      resources :versions, controller: 'analysis_versions' do
        member do
          post :request_heatmap
          post :request_suggestions
          get :compare
        end
      end
      resources :key_areas
    end
  end
  
  # API routes for external services
  namespace :api do
    namespace :v1 do
      resources :heatmaps, only: [:create]
      resources :suggestions, only: [:create]
    end
  end
end
```

### 8. Key Implementation Notes

1. **No Design Implementation**: Follow existing design system, focus on functionality
2. **External API Dependencies**: Heatmap and suggestion generation handled externally
3. **Version Control**: Critical for preventing AI suggestion loops
4. **Custom Scoring**: Per project-type logic with "All good!" threshold
5. **File Management**: Direct filesystem storage, organize by project/analysis hierarchy
6. **Vue.js Integration**: Mount components through ERB templates using components.ts
7. **Responsive Key Areas**: Store coordinates as percentages for cross-device compatibility

### 9. Development Priorities

1. Core models and database structure
2. Basic CRUD operations for projects and analyses
3. Image upload and version management
4. Vue.js component integration
5. External API service integrations
6. Custom scoring implementation
7. A/B testing comparison tools

This structure provides a solid foundation for the eye-tracking analysis application while maintaining flexibility for future enhancements and following Rails conventions.