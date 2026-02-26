<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Thực Admin - Cooking Share</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .pin-container {
            background: white;
            padding: 50px 40px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.4);
            width: 100%;
            max-width: 400px;
            text-align: center;
            animation: slideUp 0.5s ease;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .lock-icon {
            font-size: 60px;
            margin-bottom: 20px;
        }
        
        h2 {
            color: #1e3c72;
            margin-bottom: 10px;
            font-size: 28px;
        }
        
        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
        }
        
        .alert-error {
            background: #fee;
            color: #c33;
            border: 1px solid #fcc;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .pin-input-group {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 30px;
        }
        
        .pin-input {
            width: 60px;
            height: 60px;
            font-size: 24px;
            text-align: center;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            transition: all 0.3s;
            font-weight: bold;
        }
        
        .pin-input:focus {
            outline: none;
            border-color: #1e3c72;
            box-shadow: 0 0 0 3px rgba(30, 60, 114, 0.1);
        }
        
        .pin-input.filled {
            background: #f0f4ff;
            border-color: #1e3c72;
        }
        
        .btn {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(30, 60, 114, 0.4);
        }
        
        .btn-primary:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }
        
        .back-link {
            margin-top: 20px;
        }
        
        .back-link a {
            color: #1e3c72;
            text-decoration: none;
            font-size: 14px;
        }
        
        .back-link a:hover {
            text-decoration: underline;
        }
        
        .warning {
            background: #fff3cd;
            border: 1px solid #ffc107;
            color: #856404;
            padding: 10px;
            border-radius: 8px;
            margin-top: 20px;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="pin-container">
        <div class="lock-icon">🔐</div>
        <h2>Xác Thực Admin</h2>
        <p class="subtitle">Vui lòng nhập mã PIN để tiếp tục</p>
        
        <% if (request.getAttribute("pinError") != null) { %>
            <div class="alert-error">
                ⚠️ <%= request.getAttribute("pinError") %>
            </div>
        <% } %>
        
        <form action="LoginServlet" method="post" id="pinForm">
            <input type="hidden" name="action" value="checkAdminPin">
            <input type="hidden" name="pin" id="hiddenPin">
            
            <div class="pin-input-group">
                <input type="text" maxlength="1" class="pin-input" data-index="0" autocomplete="off">
                <input type="text" maxlength="1" class="pin-input" data-index="1" autocomplete="off">
                <input type="text" maxlength="1" class="pin-input" data-index="2" autocomplete="off">
                <input type="text" maxlength="1" class="pin-input" data-index="3" autocomplete="off">
            </div>
            
            <button type="submit" class="btn btn-primary" id="submitBtn" disabled>Xác Nhận</button>
        </form>
        
        <div class="back-link">
            <a href="LoginServlet">← Quay lại đăng nhập User</a>
        </div>
        
        <div class="warning">
            ⚠️ Chỉ dành cho quản trị viên hệ thống
        </div>
    </div>
    
    <script>
        const inputs = document.querySelectorAll('.pin-input');
        const hiddenPin = document.getElementById('hiddenPin');
        const submitBtn = document.getElementById('submitBtn');
        const pinForm = document.getElementById('pinForm');
        
        inputs[0].focus();
        
        inputs.forEach((input, index) => {
            input.addEventListener('input', (e) => {
                const value = e.target.value;
                
                if (value && !/^\d$/.test(value)) {
                    e.target.value = '';
                    return;
                }
                
                if (value) {
                    input.classList.add('filled');
                    if (index < inputs.length - 1) {
                        inputs[index + 1].focus();
                    }
                } else {
                    input.classList.remove('filled');
                }
                
                updatePin();
            });
            
            input.addEventListener('keydown', (e) => {
                if (e.key === 'Backspace' && !input.value && index > 0) {
                    inputs[index - 1].focus();
                }
            });
            
            input.addEventListener('paste', (e) => {
                e.preventDefault();
                const pasteData = e.clipboardData.getData('text').slice(0, 4);
                
                if (/^\d+$/.test(pasteData)) {
                    pasteData.split('').forEach((char, i) => {
                        if (inputs[i]) {
                            inputs[i].value = char;
                            inputs[i].classList.add('filled');
                        }
                    });
                    inputs[Math.min(pasteData.length, 3)].focus();
                    updatePin();
                }
            });
        });
        
        function updatePin() {
            let pin = '';
            inputs.forEach(input => {
                pin += input.value || '';
            });
            
            hiddenPin.value = pin;
            submitBtn.disabled = pin.length !== 4;
            
            if (pin.length === 4) {
                setTimeout(() => {
                    pinForm.submit();
                }, 300);
            }
        }
    </script>
</body>
</html>