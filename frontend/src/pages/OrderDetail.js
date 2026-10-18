import React from 'react';
import { useParams, Link } from 'react-router-dom';
import { useQuery } from 'react-query';
import { orderService } from '../services/api';

const OrderDetail = () => {
  const { id } = useParams();

  const { data: order, isLoading, error } = useQuery(
    ['order', id],
    () => orderService.getOrder(id),
    {
      select: (response) => response.data,
      enabled: !!id
    }
  );

  const formatPrice = (price) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(price);
  };

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  if (isLoading) {
    return (
      <div className="container" style={{ padding: '3rem 0', textAlign: 'center' }}>
        <div className="spinner"></div>
        <p>Loading order details...</p>
      </div>
    );
  }

  if (error || !order) {
    return (
      <div className="container" style={{ padding: '3rem 0', textAlign: 'center' }}>
        <h2>Order Not Found</h2>
        <p>Could not load details for this order.</p>
        <Link to="/orders" className="btn btn-primary" style={{ marginTop: '1rem' }}>
          Back to Orders
        </Link>
      </div>
    );
  }

  return (
    <div className="container" style={{ padding: '2rem 0' }}>
      <Link to="/orders" className="btn btn-outline" style={{ marginBottom: '1.5rem' }}>
        &larr; Back to Orders
      </Link>

      <div style={{ backgroundColor: 'white', borderRadius: '10px', padding: '2rem', boxShadow: '0 2px 10px rgba(0,0,0,0.1)' }}>
        <h2 style={{ marginBottom: '0.5rem' }}>Order #{order.orderNumber}</h2>
        <p style={{ color: '#6c757d', marginBottom: '1.5rem' }}>Placed on {formatDate(order.createdAt)}</p>

        <h4 style={{ marginBottom: '1rem' }}>Items</h4>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem', marginBottom: '2rem' }}>
          {order.items.map((item, index) => (
            <div key={index} style={{ display: 'flex', justifyContent: 'space-between', padding: '0.75rem', backgroundColor: '#f8f9fa', borderRadius: '8px' }}>
              <div>
                <div style={{ fontWeight: 'bold' }}>{item.productDetails?.name || 'Product'}</div>
                <div style={{ color: '#6c757d', fontSize: '0.9rem' }}>Qty: {item.quantity}</div>
              </div>
              <div style={{ textAlign: 'right' }}>
                <div style={{ fontWeight: 'bold' }}>{formatPrice(item.total)}</div>
              </div>
            </div>
          ))}
        </div>

        <div style={{ borderTop: '1px solid #e9ecef', paddingTop: '1.5rem', display: 'flex', justifyContent: 'flex-end' }}>
          <div style={{ textAlign: 'right' }}>
            <p>Subtotal: {formatPrice(order.pricing.subtotal)}</p>
            <p>Shipping: {formatPrice(order.pricing.shipping)}</p>
            <p>Tax: {formatPrice(order.pricing.tax)}</p>
            <h3>Total: {formatPrice(order.pricing.total)}</h3>
          </div>
        </div>
      </div>
    </div>
  );
};

export default OrderDetail;