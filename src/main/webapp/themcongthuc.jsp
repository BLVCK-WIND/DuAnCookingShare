<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, Model.danhmuc, Model.user" %>
<%
    request.setAttribute("pageTitle", "Tạo Công Thức Mới - CookingShare");
    
	user currentUser = (user) session.getAttribute("user_user");
    @SuppressWarnings("unchecked")
    List<danhmuc> categories = (List<danhmuc>) request.getAttribute("categories");
%>

<!-- Include Header -->
<jsp:include page="include/header.jsp" />

<style>
    /* Custom scrollbar */
    ::-webkit-scrollbar {
        width: 8px;
    }
    ::-webkit-scrollbar-track {
        background: transparent;
    }
    ::-webkit-scrollbar-thumb {
        background: #d1c5bb;
        border-radius: 4px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: var(--primary);
    }
    
    /* Main content */
    .main-content {
        min-height: calc(100vh - 200px);
        padding: 2rem 1rem;
    }
    
    .content-wrapper {
        max-width: 960px;
        margin: 0 auto;
        width: 100%;
    }
    
    @media (min-width: 768px) {
        .main-content {
            padding: 2rem 2.5rem;
        }
    }
    
    @media (min-width: 1024px) {
        .main-content {
            padding: 2rem 10rem;
        }
    }
    
    /* Breadcrumbs */
    .breadcrumbs {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
        margin-bottom: 1.5rem;
        font-size: 1rem;
        font-weight: 500;
    }
    
    .breadcrumb-link {
        color: var(--text-secondary);
        transition: color 0.3s;
        text-decoration: none;
    }
    
    .breadcrumb-link:hover {
        color: var(--primary);
    }
    
    .breadcrumb-separator {
        color: var(--text-secondary);
    }
    
    .breadcrumb-current {
        color: var(--text-main);
    }
    
    /* Page heading */
    .page-heading {
        margin-bottom: 2rem;
    }
    
    .page-heading h1 {
        font-size: 2.5rem;
        font-weight: 800;
        color: var(--text-main);
        line-height: 1.2;
        letter-spacing: -0.033em;
        margin-bottom: 0.5rem;
    }
    
    .page-heading p {
        font-size: 1rem;
        color: var(--text-secondary);
    }
    
    /* Form sections */
    .form-section {
        background: white;
        border-radius: 0.75rem;
        padding: 1.5rem;
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        margin-bottom: 2rem;
    }
    
    .section-title {
        font-size: 1.25rem;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 1.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    /* Image upload */
    .image-upload-area {
        position: relative;
        min-height: 280px;
        width: 100%;
        border: 2px dashed var(--border-color);
        border-radius: 0.75rem;
        background: #fafafa;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 2rem;
    }
    
    .image-upload-area:hover {
        border-color: var(--primary);
        background: rgba(238, 134, 43, 0.05);
    }
    
    .upload-icon-wrapper {
        width: 4rem;
        height: 4rem;
        border-radius: 50%;
        background: rgba(238, 134, 43, 0.1);
        color: var(--primary);
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 1rem;
        transition: all 0.3s;
    }
    
    .image-upload-area:hover .upload-icon-wrapper {
        background: var(--primary);
        color: white;
    }
    
    .upload-icon {
        font-size: 2.5rem;
    }
    
    .upload-text {
        text-align: center;
    }
    
    .upload-title {
        font-size: 1rem;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 0.25rem;
    }
    
    .upload-subtitle {
        font-size: 0.875rem;
        color: var(--text-secondary);
        margin-bottom: 0.5rem;
    }
    
    .upload-hint {
        font-size: 0.75rem;
        color: var(--text-secondary);
    }
    
    /* Image preview */
    .image-preview {
        display: none;
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        border-radius: 0.75rem;
        overflow: hidden;
    }
    
    .image-preview img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    
    .image-preview.active {
        display: block;
    }
    
    .remove-image-btn {
        position: absolute;
        top: 0.5rem;
        right: 0.5rem;
        width: 2.5rem;
        height: 2.5rem;
        border-radius: 50%;
        background: rgba(239, 68, 68, 0.9);
        color: white;
        border: none;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        z-index: 10;
        transition: all 0.3s;
    }
    
    .remove-image-btn:hover {
        background: #dc2626;
        transform: scale(1.1);
    }
    
    /* Form grid */
    .form-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 2rem;
    }
    
    @media (min-width: 1024px) {
        .form-grid {
            grid-template-columns: 1fr 2fr;
        }
    }
    
    .detail-grid {
        display: grid;
        grid-template-columns: 1fr;
        gap: 1rem;
    }
    
    @media (min-width: 640px) {
        .detail-grid {
            grid-template-columns: repeat(2, 1fr);
        }
    }
    
    @media (min-width: 1024px) {
        .detail-grid {
            grid-template-columns: repeat(4, 1fr);
        }
    }
    
    /* Form controls */
    .form-group {
        margin-bottom: 1.25rem;
    }
    
    .form-group:last-child {
        margin-bottom: 0;
    }
    
    .form-label {
        display: block;
        font-size: 0.875rem;
        font-weight: 700;
        color: var(--text-main);
        margin-bottom: 0.5rem;
    }
    
    .form-label.with-icon {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .form-label .material-symbols-outlined {
        color: var(--primary);
        font-size: 1.25rem;
    }
    
    .required {
        color: #ef4444;
    }
    
    .form-input,
    .form-textarea,
    .form-select {
        width: 100%;
        padding: 0.75rem 1rem;
        border: 1px solid var(--border-color);
        border-radius: 0.5rem;
        background: white;
        color: var(--text-main);
        font-size: 1rem;
        transition: all 0.3s;
    }
    
    .form-input:focus,
    .form-textarea:focus,
    .form-select:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(238, 134, 43, 0.1);
    }
    
    .form-textarea {
        resize: vertical;
        min-height: 100px;
    }
    
    .input-with-unit {
        position: relative;
    }
    
    .input-unit {
        position: absolute;
        right: 1rem;
        top: 50%;
        transform: translateY(-50%);
        font-size: 0.875rem;
        color: var(--text-secondary);
    }
    
    /* Ingredients */
    .ingredients-list {
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
    }
    
    .ingredient-row {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }
    
    @media (min-width: 640px) {
        .ingredient-row {
            flex-direction: row;
            align-items: center;
        }
    }
    
    .ingredient-quantity {
        width: 100%;
    }
    
    @media (min-width: 640px) {
        .ingredient-quantity {
            width: 25%;
        }
    }
    
    .ingredient-name-wrapper {
        display: flex;
        flex: 1;
        gap: 0.5rem;
    }
    
    .ingredient-name {
        flex: 1;
    }
    
    .remove-btn {
        width: 2.5rem;
        height: 2.5rem;
        border-radius: 0.5rem;
        background: transparent;
        border: none;
        color: var(--text-secondary);
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .remove-btn:hover {
        background: #fef2f2;
        color: #ef4444;
    }
    
    /* Steps */
    .steps-list {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
    }
    
    .step-item {
        display: flex;
        gap: 1rem;
    }
    
    .step-number {
        width: 2rem;
        height: 2rem;
        border-radius: 50%;
        background: var(--primary);
        color: white;
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
        box-shadow: 0 2px 4px rgba(238, 134, 43, 0.2);
    }
    
    .step-content {
        flex: 1;
    }
    
    .step-actions {
        display: flex;
        justify-content: flex-end;
        margin-top: 0.5rem;
    }
    
    .step-remove {
        font-size: 0.75rem;
        font-weight: 500;
        color: var(--text-secondary);
        background: none;
        border: none;
        cursor: pointer;
        transition: color 0.3s;
    }
    
    .step-remove:hover {
        color: #ef4444;
    }
    
    /* Add buttons */
    .add-btn {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.875rem;
        font-weight: 600;
        color: var(--primary);
        background: none;
        border: none;
        cursor: pointer;
        transition: all 0.3s;
    }
    
    .add-btn:hover {
        opacity: 0.8;
    }
    
    .add-btn .material-symbols-outlined {
        font-size: 1.25rem;
    }
    
    /* Action bar */
    .action-bar {
        position: sticky;
        bottom: 1rem;
        z-index: 50;
        margin-top: 2rem;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(8px);
        border: 1px solid var(--border-color);
        border-radius: 0.75rem;
        padding: 1rem;
        display: flex;
        justify-content: flex-end;
        gap: 1rem;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    
    .btn {
        padding: 0.75rem 1.5rem;
        border-radius: 0.5rem;
        font-size: 0.875rem;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s;
        border: 1px solid transparent;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .btn-cancel {
        background: transparent;
        color: var(--text-secondary);
        border-color: var(--border-color);
    }
    
    .btn-cancel:hover {
        background: #f9fafb;
        color: var(--text-main);
    }
    
    .btn-reset {
        background: white;
        color: var(--text-main);
        border-color: var(--border-color);
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    }
    
    .btn-reset:hover {
        background: #f9fafb;
    }
    
    .btn-submit {
        background: var(--primary);
        color: white;
        box-shadow: 0 2px 4px rgba(238, 134, 43, 0.2);
    }
    
    .btn-submit:hover {
        background: var(--primary-hover);
        box-shadow: 0 4px 8px rgba(238, 134, 43, 0.3);
    }
    
    .btn .material-symbols-outlined {
        font-size: 1.25rem;
    }
</style>

<!-- MAIN CONTENT -->
<main class="main-content">
    <div class="content-wrapper">
        <!-- Breadcrumbs -->
        <div class="breadcrumbs">
            <a href="<%= request.getContextPath() %>/HomeServlet" class="breadcrumb-link">Trang chủ</a>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current">Tạo công thức</span>
        </div>

        <!-- Page Heading -->
        <div class="page-heading">
            <h1>Tạo Công Thức Mới</h1>
            <p>Chia sẻ bí quyết nấu ăn tuyệt vời của bạn với cộng đồng.</p>
        </div>

        <!-- Form -->
        <form method="post" action="<%= request.getContextPath() %>/ThemCongThucServlet" enctype="multipart/form-data">
            
            <!-- Section 1: Image & Basic Info -->
            <div class="form-grid">
                <!-- Image Upload -->
                <div>
                    <label class="image-upload-area" id="imageUploadArea">
                        <div class="upload-icon-wrapper">
                            <span class="material-symbols-outlined upload-icon">cloud_upload</span>
                        </div>
                        <div class="upload-text">
                            <div class="upload-title">Tải ảnh món ăn</div>
                            <div class="upload-subtitle">Kéo thả hoặc nhấn để tải lên</div>
                            <div class="upload-hint">(JPG, PNG tối đa 5MB)</div>
                        </div>
                        <input type="file" 
                               name="image" 
                               id="imageInput" 
                               accept="image/*" 
                               style="display: none;" 
                               required>
                        
                        <div class="image-preview" id="imagePreview">
                            <img src="" alt="Preview" id="previewImage">
                            <button type="button" class="remove-image-btn" id="removeImageBtn">
                                <span class="material-symbols-outlined">close</span>
                            </button>
                        </div>
                    </label>
                </div>

                <!-- Basic Details -->
                <div class="form-section">
                    <h3 class="section-title">Thông tin cơ bản</h3>
                    
                    <div class="form-group">
                        <label class="form-label">
                            Tiêu đề công thức <span class="required">*</span>
                        </label>
                        <input type="text" 
                               name="title" 
                               class="form-input" 
                               placeholder="Ví dụ: Phở Bò Nam Định" 
                               required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Mô tả nhanh</label>
                        <textarea name="description" 
                                  class="form-textarea" 
                                  rows="3"
                                  placeholder="Giới thiệu ngắn gọn về món ăn, hương vị và nguồn cảm hứng của bạn..."></textarea>
                    </div>
                </div>
            </div>

            <!-- Section 2: Details Grid -->
            <div class="detail-grid">
                <!-- Cooking Time -->
                <div class="form-section">
                    <div class="form-group">
                        <label class="form-label with-icon">
                            <span class="material-symbols-outlined">schedule</span>
                            Thời gian nấu
                        </label>
                        <div class="input-with-unit">
                            <input type="number" 
                                   name="cookingTime" 
                                   class="form-input" 
                                   placeholder="45" 
                                   min="1" 
                                   required>
                            <span class="input-unit">phút</span>
                        </div>
                    </div>
                </div>

                <!-- Difficulty -->
                <div class="form-section">
                    <div class="form-group">
                        <label class="form-label with-icon">
                            <span class="material-symbols-outlined">signal_cellular_alt</span>
                            Độ khó
                        </label>
                        <select name="difficulty" class="form-select" required>
                            <option value="easy">Dễ</option>
                            <option value="medium" selected>Trung bình</option>
                            <option value="hard">Khó</option>
                        </select>
                    </div>
                </div>

                <!-- Servings -->
                <div class="form-section">
                    <div class="form-group">
                        <label class="form-label with-icon">
                            <span class="material-symbols-outlined">restaurant_menu</span>
                            Khẩu phần
                        </label>
                        <div class="input-with-unit">
                            <input type="number" 
                                   name="servings" 
                                   class="form-input" 
                                   placeholder="2" 
                                   min="1" 
                                   required>
                            <span class="input-unit">người</span>
                        </div>
                    </div>
                </div>

                <!-- Category -->
                <div class="form-section">
                    <div class="form-group">
                        <label class="form-label with-icon">
                            <span class="material-symbols-outlined">category</span>
                            Danh mục
                        </label>
                        <select name="categoryId" class="form-select" required>
                            <option value="">Chọn danh mục</option>
                            <% if (categories != null) {
                                for (danhmuc category : categories) { %>
                                    <option value="<%= category.getCategoryId() %>"><%= category.getCategoryName() %></option>
                            <%  }
                            } %>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Section 3: Ingredients -->
            <div class="form-section">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                    <h3 class="section-title" style="margin: 0;">Nguyên liệu</h3>
                    <button type="button" class="add-btn" onclick="addIngredient()">
                        <span class="material-symbols-outlined">add_circle</span>
                        Thêm nguyên liệu
                    </button>
                </div>
                
                <div class="ingredients-list" id="ingredientsList">
                    <div class="ingredient-row">
                        <input type="text" 
                               name="ingredientQuantity[]" 
                               class="form-input ingredient-quantity" 
                               placeholder="Số lượng (vd: 500g)">
                        <div class="ingredient-name-wrapper">
                            <input type="text" 
                                   name="ingredientName[]" 
                                   class="form-input ingredient-name" 
                                   placeholder="Tên nguyên liệu (vd: Thịt bò thăn)">
                            <button type="button" class="remove-btn" onclick="removeIngredient(this)">
                                <span class="material-symbols-outlined">delete</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Section 4: Steps -->
            <div class="form-section">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                    <h3 class="section-title" style="margin: 0;">Các bước thực hiện</h3>
                    <button type="button" class="add-btn" onclick="addStep()">
                        <span class="material-symbols-outlined">add_circle</span>
                        Thêm bước
                    </button>
                </div>
                
                <div class="steps-list" id="stepsList">
                    <div class="step-item">
                        <div class="step-number">1</div>
                        <div class="step-content">
                            <textarea name="step[]" 
                                      class="form-textarea" 
                                      rows="3"
                                      placeholder="Mô tả chi tiết bước này. Ví dụ: Rửa sạch thịt bò, thái lát mỏng..."></textarea>
                            <div class="step-actions">
                                <button type="button" class="step-remove" onclick="removeStep(this)">Xóa bước</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Section 5: Notes -->
            <div class="form-section">
                <h3 class="section-title">
                    Ghi chú thêm <span style="font-weight: 400; font-size: 0.875rem; color: var(--text-secondary);">(Không bắt buộc)</span>
                </h3>
                <textarea name="notes" 
                          class="form-textarea" 
                          rows="4"
                          placeholder="Mẹo nhỏ, lưu ý khi nấu hoặc cách bảo quản..."></textarea>
            </div>

            <!-- Action Bar -->
            <div class="action-bar">
                <button type="button" class="btn btn-cancel" onclick="history.back()">Hủy bỏ</button>
                <button type="reset" class="btn btn-reset" onclick="resetForm()">Nhập lại</button>
                <button type="submit" class="btn btn-submit">
                    <span class="material-symbols-outlined">publish</span>
                    Đăng công thức
                </button>
            </div>
        </form>
    </div>
</main>

<script>
    // Image upload preview
    const imageInput = document.getElementById('imageInput');
    const imagePreview = document.getElementById('imagePreview');
    const previewImage = document.getElementById('previewImage');
    const removeImageBtn = document.getElementById('removeImageBtn');
    const imageUploadArea = document.getElementById('imageUploadArea');

    imageInput.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            // Check if file is image
            if (!file.type.startsWith('image/')) {
                alert('Chỉ được upload file ảnh!');
                this.value = '';
                return;
            }
            
            // Check file size (5MB)
            if (file.size > 5 * 1024 * 1024) {
                alert('Kích thước file không được vượt quá 5MB!');
                this.value = '';
                return;
            }
            
            const reader = new FileReader();
            reader.onload = function(e) {
                previewImage.src = e.target.result;
                imagePreview.classList.add('active');
            };
            reader.readAsDataURL(file);
        }
    });

    removeImageBtn.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        imageInput.value = '';
        imagePreview.classList.remove('active');
        previewImage.src = '';
    });

    // Add ingredient
    function addIngredient() {
        const ingredientsList = document.getElementById('ingredientsList');
        const newIngredient = document.createElement('div');
        newIngredient.className = 'ingredient-row';
        newIngredient.innerHTML = `
            <input type="text" 
                   name="ingredientQuantity[]" 
                   class="form-input ingredient-quantity" 
                   placeholder="Số lượng">
            <div class="ingredient-name-wrapper">
                <input type="text" 
                       name="ingredientName[]" 
                       class="form-input ingredient-name" 
                       placeholder="Tên nguyên liệu">
                <button type="button" class="remove-btn" onclick="removeIngredient(this)">
                    <span class="material-symbols-outlined">delete</span>
                </button>
            </div>
        `;
        ingredientsList.appendChild(newIngredient);
    }

    function removeIngredient(btn) {
        const ingredientRow = btn.closest('.ingredient-row');
        if (document.querySelectorAll('.ingredient-row').length > 1) {
            ingredientRow.remove();
        } else {
            alert('Phải có ít nhất 1 nguyên liệu!');
        }
    }

    // Add step
    let stepCounter = 1;
    function addStep() {
        stepCounter++;
        const stepsList = document.getElementById('stepsList');
        const newStep = document.createElement('div');
        newStep.className = 'step-item';
        newStep.innerHTML = `
            <div class="step-number">${stepCounter}</div>
            <div class="step-content">
                <textarea name="step[]" 
                          class="form-textarea" 
                          rows="3"
                          placeholder="Mô tả chi tiết bước này..."></textarea>
                <div class="step-actions">
                    <button type="button" class="step-remove" onclick="removeStep(this)">Xóa bước</button>
                </div>
            </div>
        `;
        stepsList.appendChild(newStep);
        updateStepNumbers();
    }

    function removeStep(btn) {
        const stepItem = btn.closest('.step-item');
        if (document.querySelectorAll('.step-item').length > 1) {
            stepItem.remove();
            stepCounter--;
            updateStepNumbers();
        } else {
            alert('Phải có ít nhất 1 bước thực hiện!');
        }
    }

    function updateStepNumbers() {
        const stepItems = document.querySelectorAll('.step-item');
        stepItems.forEach((item, index) => {
            item.querySelector('.step-number').textContent = index + 1;
        });
    }

    // Reset form
    function resetForm() {
        if (confirm('Bạn có chắc muốn nhập lại? Tất cả dữ liệu sẽ bị xóa.')) {
            imageInput.value = '';
            imagePreview.classList.remove('active');
            previewImage.src = '';
        }
    }

    // Form submission
    document.querySelector('form').addEventListener('submit', function(e) {
        // Combine ingredients
        const quantities = document.querySelectorAll('input[name="ingredientQuantity[]"]');
        const names = document.querySelectorAll('input[name="ingredientName[]"]');
        let ingredientsText = '';
        
        for (let i = 0; i < quantities.length; i++) {
            const qty = quantities[i].value.trim();
            const name = names[i].value.trim();
            if (qty && name) {
                ingredientsText += qty + ' ' + name + '\n';
            }
        }
        
        // Create hidden input for ingredients
        const ingredientsInput = document.createElement('input');
        ingredientsInput.type = 'hidden';
        ingredientsInput.name = 'ingredients';
        ingredientsInput.value = ingredientsText.trim();
        this.appendChild(ingredientsInput);
        
        // Combine steps
        const steps = document.querySelectorAll('textarea[name="step[]"]');
        let instructionsText = '';
        
        steps.forEach((step, index) => {
            const stepText = step.value.trim();
            if (stepText) {
                instructionsText += 'Bước ' + (index + 1) + ': ' + stepText + '\n\n';
            }
        });
        
        // Create hidden input for instructions
        const instructionsInput = document.createElement('input');
        instructionsInput.type = 'hidden';
        instructionsInput.name = 'instructions';
        instructionsInput.value = instructionsText.trim();
        this.appendChild(instructionsInput);
    });
</script>

<!-- Include Footer -->
<jsp:include page="include/footer.jsp" />
