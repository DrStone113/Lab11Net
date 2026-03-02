<%@ Page Title="Trang chủ cán bộ" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SinhVienWeb._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="page-header">
        <div class="header-content">
            <div>
                <h2>Tổng quan về khóa học</h2>
                <asp:Label ID="lblXinChao" runat="server" Font-Bold="true" CssClass="welcome-text"></asp:Label>
            </div>
            <asp:Button ID="btnDangXuat" runat="server" Text="Đăng xuất" OnClick="btnDangXuat_Click" CssClass="btn btn-danger" />
        </div>
    </div>

    <div class="course-controls">
        <div class="search-section">
            <input type="text" id="txtSearch" class="search-input" placeholder="Tìm kiếm" onkeyup="filterCourses()" />
            <button type="button" class="btn-clear" onclick="clearSearch()">×</button>
        </div>
        <div class="sort-section">
            <div class="dropdown">
                <button type="button" class="btn-sort" onclick="toggleSortDropdown()">
                    <span id="sortLabel">Sort by course name</span> ▼
                </button>
                <div id="sortDropdown" class="dropdown-menu">
                    <a href="#" onclick="sortCourses('name'); return false;">Sort by course name</a>
                    <a href="#" onclick="sortCourses('code'); return false;">Sort by course code</a>
                    <a href="#" onclick="sortCourses('class'); return false;">Sort by class</a>
                </div>
            </div>
            <button type="button" class="btn-view" onclick="toggleView()">
                <span id="viewLabel">Card</span>
            </button>
        </div>
    </div>

    <div class="courses-grid" id="coursesGrid">
        <asp:Repeater ID="rptCourses" runat="server">
            <ItemTemplate>
                <div class="course-card" data-course-name="<%# Eval("TenMon").ToString().ToLower() %>" data-course-code="<%# Eval("MaMon").ToString().ToLower() %>" data-class="<%# Eval("TenLop").ToString().ToLower() %>" style='<%# "background: " + GetCardGradient(Container.ItemIndex) %>'>
                    <div class="card-overlay">
                        <div class="card-header-badge">
                            <span class="completion-badge">0% complete</span>
                        </div>
                        <div class="card-body">
                            <h3 class="course-title"><%# Eval("TenMon") %></h3>
                            <div class="course-details">
                                <p class="course-info">
                                    <span class="info-label">Mã môn:</span> 
                                    <span class="info-value"><%# Eval("MaMon") %></span>
                                </p>
                                <p class="course-info">
                                    <span class="info-label">Lớp:</span> 
                                    <span class="info-value"><%# Eval("TenLop") %> (<%# Eval("MaLop") %>)</span>
                                </p>
                            </div>
                        </div>
                        <div class="card-footer">
                            <a href='<%# "NhapDiem.aspx?MaMon=" + Eval("MaMon") + "&MaLop=" + Eval("MaLop") %>' 
                               class="btn-update">
                                Cập nhật điểm
                            </a>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <script type="text/javascript">
        var currentSort = 'name';
        var isDropdownOpen = false;
        
        // Hàm loại bỏ dấu tiếng Việt
        function removeVietnameseTones(str) {
            str = str.toLowerCase();
            str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
            str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
            str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
            str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
            str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
            str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
            str = str.replace(/đ/g, "d");
            return str;
        }
        
        function filterCourses() {
            var searchText = document.getElementById('txtSearch').value.toLowerCase();
            var searchTextNoTone = removeVietnameseTones(searchText);
            var cards = document.querySelectorAll('.course-card');
            var hasResults = false;
            
            cards.forEach(function(card) {
                var courseName = card.getAttribute('data-course-name');
                var courseCode = card.getAttribute('data-course-code');
                var className = card.getAttribute('data-class');
                
                var courseNameNoTone = removeVietnameseTones(courseName);
                var classNameNoTone = removeVietnameseTones(className);
                
                if (courseNameNoTone.includes(searchTextNoTone) || 
                    courseName.includes(searchText) ||
                    courseCode.includes(searchText) || 
                    classNameNoTone.includes(searchTextNoTone) ||
                    className.includes(searchText)) {
                    card.style.opacity = '0';
                    card.style.display = '';
                    setTimeout(function() {
                        card.style.opacity = '1';
                    }, 10);
                    hasResults = true;
                } else {
                    card.style.opacity = '0';
                    setTimeout(function() {
                        card.style.display = 'none';
                    }, 300);
                }
            });
            
            // Hiển thị thông báo nếu không có kết quả
            var noResultMsg = document.getElementById('noResultMessage');
            if (!noResultMsg) {
                noResultMsg = document.createElement('div');
                noResultMsg.id = 'noResultMessage';
                noResultMsg.className = 'no-result-message';
                noResultMsg.innerHTML = '<p>Không tìm thấy khóa học nào phù hợp</p>';
                document.getElementById('coursesGrid').appendChild(noResultMsg);
            }
            
            if (!hasResults && searchText !== '') {
                noResultMsg.style.display = 'block';
                setTimeout(function() {
                    noResultMsg.style.opacity = '1';
                }, 10);
            } else {
                noResultMsg.style.opacity = '0';
                setTimeout(function() {
                    noResultMsg.style.display = 'none';
                }, 300);
            }
        }
        
        function clearSearch() {
            document.getElementById('txtSearch').value = '';
            filterCourses();
            document.getElementById('txtSearch').focus();
        }
        
        function toggleSortDropdown() {
            var dropdown = document.getElementById('sortDropdown');
            isDropdownOpen = !isDropdownOpen;
            dropdown.style.display = isDropdownOpen ? 'block' : 'none';
        }
        
        function sortCourses(sortBy) {
            currentSort = sortBy;
            var grid = document.getElementById('coursesGrid');
            var cards = Array.from(document.querySelectorAll('.course-card'));
            
            cards.sort(function(a, b) {
                var aValue, bValue;
                
                if (sortBy === 'name') {
                    aValue = a.getAttribute('data-course-name');
                    bValue = b.getAttribute('data-course-name');
                    document.getElementById('sortLabel').textContent = 'Sort by course name';
                } else if (sortBy === 'code') {
                    aValue = a.getAttribute('data-course-code');
                    bValue = b.getAttribute('data-course-code');
                    document.getElementById('sortLabel').textContent = 'Sort by course code';
                } else if (sortBy === 'class') {
                    aValue = a.getAttribute('data-class');
                    bValue = b.getAttribute('data-class');
                    document.getElementById('sortLabel').textContent = 'Sort by class';
                }
                
                return aValue.localeCompare(bValue, 'vi');
            });
            
            // Xóa và thêm lại các card theo thứ tự mới
            cards.forEach(function(card) {
                card.style.opacity = '0';
            });
            
            setTimeout(function() {
                cards.forEach(function(card) {
                    grid.appendChild(card);
                });
                
                setTimeout(function() {
                    cards.forEach(function(card) {
                        card.style.opacity = '1';
                    });
                }, 10);
            }, 300);
            
            toggleSortDropdown();
        }
        
        function toggleView() {
            var viewLabel = document.getElementById('viewLabel');
            var grid = document.getElementById('coursesGrid');
            
            if (viewLabel.textContent === 'Card') {
                viewLabel.textContent = 'List';
                grid.classList.add('list-view');
            } else {
                viewLabel.textContent = 'Card';
                grid.classList.remove('list-view');
            }
        }
        
        // Đóng dropdown khi click bên ngoài
        document.addEventListener('click', function(event) {
            var dropdown = document.getElementById('sortDropdown');
            var sortBtn = document.querySelector('.btn-sort');
            
            if (dropdown && sortBtn && !sortBtn.contains(event.target) && !dropdown.contains(event.target)) {
                dropdown.style.display = 'none';
                isDropdownOpen = false;
            }
        });
        
        // Ngăn form submit khi nhấn Enter trong ô tìm kiếm
        document.addEventListener('DOMContentLoaded', function() {
            var searchInput = document.getElementById('txtSearch');
            if (searchInput) {
                searchInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        return false;
                    }
                });
                
                // Thêm hiệu ứng focus
                searchInput.addEventListener('focus', function() {
                    this.parentElement.classList.add('search-focused');
                });
                
                searchInput.addEventListener('blur', function() {
                    this.parentElement.classList.remove('search-focused');
                });
            }
        });
    </script>

</asp:Content>
